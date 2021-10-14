//
//  RW_BillBreakdownModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct RW_BillBreakdownModel {
  var perPayerItemsBreakdown: [RW_Payer: RW_ItemsBreakdown] = [:]
  var perPayerAdjustmentsBreakdown: [RW_Payer: RW_AdjustmentsBreakdown] = [:]
  
  var unclaimedItems: [RW_ReceiptItemModel] = []
  
  init(payers: [RW_Payer]) {
    payers.forEach { payer in
      perPayerItemsBreakdown[payer] = .init()
      perPayerAdjustmentsBreakdown[payer] = .init()
    }
  }
  
  mutating func computePayerPortions(of subtotal: Amount) {
    perPayerItemsBreakdown.forEach { payer, itemBreakdown in
      perPayerAdjustmentsBreakdown[payer]?.percentageOfSubtotal = itemBreakdown.itemsSubtotal / subtotal
    }
  }
  
  var perPayerGrandTotals: [RW_Payer: Amount] {
    let result = perPayerItemsBreakdown.map { payer, itemBreakdown -> (RW_Payer, Amount) in
      return (payer, itemBreakdown.itemsSubtotal + (perPayerAdjustmentsBreakdown[payer]?.adjustmentsTotal ?? .zero))
    }
    
    return Dictionary(uniqueKeysWithValues: result)
  }
}

struct RW_ItemsBreakdown {
  var itemsBreakdown: [RW_ItemBreakdown] = []
  var itemsSubtotal: Amount {
    itemsBreakdown.reduce(Amount.zero) { $0 + $1.costToPayer }
  }
}

struct RW_ItemBreakdown {
  var item: RW_ReceiptItemModel
  var numPayers: Int
  var costToPayer: Amount
}

struct RW_AdjustmentsBreakdown {
  var adjustmentsBreakdown: [RW_AdjustmentBreakdown] = []
  var percentageOfSubtotal: Percentage = .zero
  
  var adjustmentsTotal: Amount {
    adjustmentsBreakdown.reduce(Amount.zero) { $0 + $1.costEquivalentToPayer }
  }
}

struct RW_AdjustmentBreakdown {
  var adjustment: RW_ReceiptAdjustmentModel
  var costEquivalentToPayer: Amount
}
