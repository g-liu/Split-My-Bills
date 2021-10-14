//
//  BillModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct BillModel {
  var payers: [PayerModel] = []
  
  var items: [ReceiptItem] = []
  var adjustments: [ReceiptAdjustment] = []
  
  var subtotal: Amount { items.reduce(Amount.zero) { $0 + $1.itemCost } }
  
  var payersNewlineDelineatedList: String {
    payers.reduce("") { $0 + "\n" + $1.person.name }
  }
  
  var splitBill: BillBreakdownModel {
    var breakdown = BillBreakdownModel(payers: payers)
    
    // Step 1: Split items
    items.forEach { item in
      if !item.isSomeonePaying {
        breakdown.unclaimedItems.append(item)
        return
      }
      
      let (costPerPayer, remainder) = item.itemCost.portion(into: item.numPayers)
      
      item.isBillableToPayer.enumerated().forEach { index, isPaying in
        let payer = payers[index]
        
        guard isPaying else {
          let itemBreakdown = ItemBreakdown(item: item, costToPayer: .zero)
          breakdown.perPayerItemsBreakdown[payer]?.itemsBreakdown.append(itemBreakdown)
          
          return
        }
        
        let itemBreakdown = ItemBreakdown(item: item, costToPayer: costPerPayer)
        breakdown.perPayerItemsBreakdown[payer]?.itemsBreakdown.append(itemBreakdown)
      }
      
      // TODO: Account for remainder.
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
    payers.forEach { payer in
      guard let payerPortion = breakdown.perPayerItemsBreakdown[payer]?.percentageOfSubtotal else { return }
      
      let adjustmentCostToPayer = cost * payerPortion
      let adjustmentCostRemaining = cost % payerPortion
      
      let adjustmentBreakdown = AdjustmentBreakdown(adjustment: adjustmentModel, costEquivalentToPayer: adjustmentCostToPayer)
      breakdown.perPayerAdjustmentsBreakdown[payer]?.adjustmentsBreakdown.append(adjustmentBreakdown)
      
      runningRemainder += adjustmentCostRemaining
    }
    
    return runningRemainder
  }
}
