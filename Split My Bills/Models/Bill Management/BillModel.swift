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
    var billBreakdown = BillBreakdownModel(persons: persons)
    var payers = persons.map { PayerModel(person: $0) }
    
    // Step 1: Split items
    items.forEach { item in
      if !item.isSomeonePaying {
        billBreakdown.addUnclaimedItem(item)
        return
      }
      
      let (costPerPayer, remainder) = item.itemCost.portion(into: item.numPayers)
      
      item.isBillableToPayer.enumerated().forEach { index, isPaying in
        let person = persons[index]
        
        let itemBreakdown = ItemBreakdown(item: item, costToPayer: isPaying ? costPerPayer : .zero)
        billBreakdown.addItemBreakdown(person: person, breakdown: itemBreakdown)
      }
      
      // TODO: THIS NEEDS TO BE MOVED OUT FOR SEPARATE TESTING!!!
      if remainder > .zero {
        var sortedPayers = payers.enumerated()
          .sorted { i1, i2 in
            let payer1 = i1.element, payer2 = i2.element
            
            if !item.isBillableToPayer[i1.offset] { return false }
            
            if payer1.remaindersPaid == payer2.remaindersPaid {
              let payer1Subtotal = billBreakdown.getSubtotal(person: payer1.person) ?? .zero
              let payer2Subtotal = billBreakdown.getSubtotal(person: payer2.person) ?? .zero
              
              if payer1Subtotal == payer2Subtotal {
                return payer1.person.name < payer2.person.name
              }
              
              return payer1Subtotal < payer2Subtotal
            }
            
            return payer1.remaindersPaid < payer2.remaindersPaid
          }
        
        // distribute the remainder for the item
        (0..<remainder.rawValue).forEach {
          let payerIndex = sortedPayers[$0].offset
          sortedPayers[$0].element.remaindersPaid += 1.amount
          
          let person = payers[payerIndex].person
          billBreakdown.adjustLastItemBreakdown(person: person, by: 1.amount)
        }
        payers = sortedPayers.map { $1 }
      }
    }
    
    // Step 2: Split adjustments
    var runningTotal: Amount = subtotal
    adjustments.forEach { adjustment in
      var runningRemainder: Double = 0.0
      
      switch adjustment.adjustment {
        case .amount(let amount):
          runningRemainder += applyCostAdjustment(adjustment, cost: amount, to: &billBreakdown)
        case .percentage(let percentage, let applicablePortion):
          let equivalentAmount: Amount
          switch applicablePortion {
            case .runningTotal:
              equivalentAmount = runningTotal * percentage
            case .subtotal:
              equivalentAmount = subtotal * percentage
          }
          runningTotal += equivalentAmount
          
          runningRemainder += applyCostAdjustment(adjustment, cost: equivalentAmount, to: &billBreakdown)
      }
      
      // TODO: Account for adjustment remainder.
    }
    
    return billBreakdown
  }
  
  private func applyCostAdjustment(_ adjustmentModel: ReceiptAdjustment, cost: Amount, to breakdown: inout BillBreakdownModel) -> Double {
    var runningRemainder: Double = 0.0
    persons.forEach { person in
      guard let payerPortion = breakdown.getPercentageOfSubtotal(person: person) else { return }
      
      let adjustmentCostToPayer = cost * payerPortion
      let adjustmentCostRemaining = cost % payerPortion
      
      let adjustmentBreakdown = AdjustmentBreakdown(adjustment: adjustmentModel, costEquivalentToPayer: adjustmentCostToPayer)
      breakdown.addAdjustmentBreakdown(person: person, breakdown: adjustmentBreakdown)
      
      runningRemainder += adjustmentCostRemaining
    }
    
    return runningRemainder
  }
}
