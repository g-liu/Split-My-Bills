//
//  BillModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct BillModel {
  var persons: [PersonModel] = []
  
  var items: [ReceiptItem] = []
  var adjustments: [ReceiptAdjustment] = []
  
  var subtotal: Amount { items.reduce(Amount.zero) { $0 + $1.itemCost } }
  
  var personsNewlineDelineatedList: String {
    persons.reduce("") { $0 + "\n" + $1.name }
  }
  
  var splitBill: BillBreakdownModel {
    var breakdown = BillBreakdownModel(persons: persons)
    var payers = persons.map { PayerModel(person: $0) }
    
    // Step 1: Split items
    items.forEach { item in
      if !item.isSomeonePaying {
        breakdown.unclaimedItems.append(item)
        return
      }
      
      let (costPerPayer, remainder) = item.itemCost.portion(into: item.numPayers)
      
      item.isBillableToPayer.enumerated().forEach { index, isPaying in
        let person = persons[index]
        
        guard isPaying else {
          let itemBreakdown = ItemBreakdown(item: item, costToPayer: .zero)
          breakdown.perPersonItemsBreakdown[person]?.itemsBreakdown.append(itemBreakdown)
          
          return
        }
        
        let itemBreakdown = ItemBreakdown(item: item, costToPayer: costPerPayer)
        breakdown.perPersonItemsBreakdown[person]?.itemsBreakdown.append(itemBreakdown)
      }
      
      // TODO: Account for remainder.
      if remainder > .zero {
        // Distribute the remainder in order of who has paid the least remainders (as a running total).
        // If two persons have paid the same remainder, tiebreak on whoever has paid more (as a running total).
        // If two persons have paid equal amounts, tiebreak on names in ascending order.
        let sortedPayersIndexesByRemaindersPaid = item.isBillableToPayer.enumerated().compactMap {
          // TODO: We only need to compact map up to `remainder.count` items.
          // So how can we make sure to exit early so we're not doing a ton of unnecessary work?
          // Might have to take a manual approach.
          $1 ? $0 : nil
        }.sorted { index1, index2 in
          let payer1 = payers[index1]
          let payer2 = payers[index2]
          if payer1.remaindersPaid == payer2.remaindersPaid {
            let payer1Subtotal = breakdown.perPersonItemsBreakdown[payer1.person]!.subtotalToPayer
            let payer2Subtotal = breakdown.perPersonItemsBreakdown[payer2.person]!.subtotalToPayer
            
            if payer1Subtotal == payer2Subtotal {
              return payer1.person.name < payer2.person.name
            }
            
            return payer1Subtotal < payer2Subtotal
          }
          
          return payer1.remaindersPaid < payer2.remaindersPaid
        }
        
        // distribute the remainder for the item
        (0..<remainder.rawValue).forEach {
          let payerIndex = sortedPayersIndexesByRemaindersPaid[$0] % payers.count
          payers[payerIndex].remaindersPaid += 1.amount
          
          let person = payers[payerIndex].person
          
          if let itemBreakdownCount = breakdown.perPersonItemsBreakdown[person]?.itemsBreakdown.count {
            let lastItemIndex = itemBreakdownCount - 1
            breakdown.perPersonItemsBreakdown[person]?.itemsBreakdown[lastItemIndex].costToPayer += 1.amount
          }
        }
      }
    }
    
    // Step 2: Split adjustments
    var runningTotal: Amount = subtotal
    adjustments.forEach { adjustment in
      var runningRemainder: Double = 0.0
      
      switch adjustment.adjustment {
        case .amount(let amount):
          runningRemainder += applyCostAdjustment(adjustment, cost: amount, to: &breakdown)
        case .percentage(let percentage, let applicablePortion):
          let equivalentAmount: Amount
          switch applicablePortion {
            case .runningTotal:
              equivalentAmount = runningTotal * percentage
            case .subtotal:
              equivalentAmount = subtotal * percentage
          }
          runningTotal += equivalentAmount
          
          runningRemainder += applyCostAdjustment(adjustment, cost: equivalentAmount, to: &breakdown)
      }
      
      // TODO: Account for adjustment remainder.
    }
    
    return breakdown
  }
  
  private func applyCostAdjustment(_ adjustmentModel: ReceiptAdjustment, cost: Amount, to breakdown: inout BillBreakdownModel) -> Double {
    var runningRemainder: Double = 0.0
    persons.forEach { person in
      guard let payerPortion = breakdown.perPersonItemsBreakdown[person]?.percentageOfSubtotal else { return }
      
      let adjustmentCostToPayer = cost * payerPortion
      let adjustmentCostRemaining = cost % payerPortion
      
      let adjustmentBreakdown = AdjustmentBreakdown(adjustment: adjustmentModel, costEquivalentToPayer: adjustmentCostToPayer)
      breakdown.perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown.append(adjustmentBreakdown)
      
      runningRemainder += adjustmentCostRemaining
    }
    
    return runningRemainder
  }
}
