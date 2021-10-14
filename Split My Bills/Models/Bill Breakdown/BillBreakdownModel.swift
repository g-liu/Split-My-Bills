//
//  BillBreakdownModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct BillBreakdownModel {
  var perPayerItemsBreakdown: [PayerModel: ItemsBreakdown] = [:]
  var perPayerAdjustmentsBreakdown: [PayerModel: AdjustmentsBreakdown] = [:]
  
  var unclaimedItems: [ReceiptItem] = []
  
  init(payers: [PayerModel]) {
    payers.forEach { payer in
      perPayerItemsBreakdown[payer] = .init()
      perPayerAdjustmentsBreakdown[payer] = .init()
    }
  }
  
  mutating func computePayerPortions(of subtotal: Amount) {
    perPayerItemsBreakdown.forEach { payer, itemBreakdown in
      perPayerAdjustmentsBreakdown[payer]?.percentageOfSubtotal = itemBreakdown.itemsSubtotal * 100 / subtotal
    }
  }
  
  var perPayerGrandTotals: [PayerModel: Amount] {
    let result = perPayerItemsBreakdown.map { payer, itemBreakdown -> (PayerModel, Amount) in
      return (payer, itemBreakdown.itemsSubtotal + (perPayerAdjustmentsBreakdown[payer]?.adjustmentsTotal ?? .zero))
    }
    
    return Dictionary(uniqueKeysWithValues: result)
  }
}
