//
//  BillModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct RW_BillModel {
  var payers: [RW_Payer]
  
  var items: [RW_ReceiptItemModel]
  var adjustments: [RW_ReceiptAdjustmentModel]
  
  var subtotal: Amount { items.reduce(Amount.zero) { $0 + $1.itemCost } }
  
  var splitBill: RW_BillBreakdownModel {
    var breakdown = RW_BillBreakdownModel(payers: payers)
    
    // Step 1: Split items
    items.forEach { item in
      if !item.isSomeonePaying {
        breakdown.unclaimedItems.append(item)
        return
      }
      
      let (costPerPayer, remainder) = item.itemCost.portion(into: item.numPayers)
      
      item.whoIsPaying.enumerated().forEach { index, isPaying in
        guard isPaying else { return }
        
        let payer = payers[index]
        let itemBreakdown = RW_ItemBreakdown(item: item, numPayers: item.numPayers, costToPayer: costPerPayer)
        breakdown.perPayerItemsBreakdown[payer]?.itemsBreakdown.append(itemBreakdown)
      }
      
      // TODO: Account for remainder.
    }
    
    breakdown.computePayerPortions(of: subtotal)
    
    // Step 2: Split adjustments
    var runningTotal: Amount = subtotal
    adjustments.forEach { adjustment in
      var runningRemainder: Double = 0.0
      
      switch adjustment.adjustment {
        case .amount(let amount):
          runningRemainder += applyCostAdjustment(adjustment, cost: amount, to: &breakdown)
        case .percentage(_, let applicablePortion):
          let equivalentAmount: Amount
          switch applicablePortion {
            case .runningTotal:
              equivalentAmount = runningTotal.adjusted(by: adjustment.adjustment)
            case .subtotal:
              equivalentAmount = subtotal.adjusted(by: adjustment.adjustment)
          }
          runningTotal += equivalentAmount
          
          runningRemainder += applyCostAdjustment(adjustment, cost: equivalentAmount, to: &breakdown)
      }
      
      // TODO: Account for adjustment remainder.
    }
    
    return breakdown
  }
  
  private func applyCostAdjustment(_ adjustmentModel: RW_ReceiptAdjustmentModel, cost: Amount, to breakdown: inout RW_BillBreakdownModel) -> Double {
    var runningRemainder: Double = 0.0
    payers.forEach { payer in
      guard let payerPortion = breakdown.perPayerAdjustmentsBreakdown[payer]?.percentageOfSubtotal else { return }
      
      let adjustmentCostToPayer = cost * payerPortion
      let adjustmentCostRemaining = cost % payerPortion
      
      let adjustmentBreakdown = RW_AdjustmentBreakdown(adjustment: adjustmentModel, costEquivalentToPayer: adjustmentCostToPayer)
      breakdown.perPayerAdjustmentsBreakdown[payer]?.adjustmentsBreakdown.append(adjustmentBreakdown)
      
      runningRemainder += adjustmentCostRemaining
    }
    
    return runningRemainder
  }
}

struct RW_Payer: Hashable {
  var person: PersonModel
  var remaindersPaid: Amount
}

struct RW_ReceiptItemModel {
  var itemName: String
  var itemCost: Amount
  
  var whoIsPaying: [Bool]
  
  var isSomeonePaying: Bool { whoIsPaying.contains(true) }
  var numPayers: Int { whoIsPaying.sum }
}

struct RW_ReceiptAdjustmentModel {
  var adjustmentName: String
  var adjustment: Adjustment
}
