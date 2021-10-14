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
  
  var perPayerGrandTotals: [PayerModel: Amount] {
    let result = perPayerItemsBreakdown.map { payer, itemBreakdown -> (PayerModel, Amount) in
      return (payer, itemBreakdown.subtotalToPayer + (perPayerAdjustmentsBreakdown[payer]?.adjustmentsTotal ?? .zero))
    }
    
    return Dictionary(uniqueKeysWithValues: result)
  }
}
