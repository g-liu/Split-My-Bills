//
//  BillByPerson.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

struct BillByPerson {
  var billLiabilities: [PersonModel: BillLiability]
  var leftoverItems: BillLiability
  
  var leftoverAmount: Amount {
    leftoverItems.itemsBreakdown.reduce(Amount.zero) { (result, itemBreakdown) -> Amount in
      let (_, breakdown) = itemBreakdown
      return result + breakdown.liabilityForItem
    }
  }
  
  init(payers: [PersonModel]) {
    leftoverItems = .init()
    self.billLiabilities = payers.reduce([:], { (result, personModel) -> [PersonModel: BillLiability] in
      var dict = result
      dict[personModel] = BillLiability()
      return dict
    })
  }
}


struct BillLiability {
  typealias ItemsBreakdown = [ReceiptItemModel: ItemBreakdown]
  typealias AdjustmentsBreakdown = [ReceiptAdjustmentModel: AdjustmentBreakdown]
  
  var totalOwed: Amount
  
  var itemsBreakdown: ItemsBreakdown
  var adjustmentsBreakdown: AdjustmentsBreakdown
  
  init(itemsBreakdown: ItemsBreakdown = [:], adjustmentsBreakdown: AdjustmentsBreakdown = [:]) {
    self.totalOwed = .zero
    self.itemsBreakdown = itemsBreakdown
    self.adjustmentsBreakdown = adjustmentsBreakdown
  }
}
extension BillLiability: Equatable, Hashable { }

struct ItemBreakdown {
  var splitCount: Int
  var liabilityForItem: Amount
}
extension ItemBreakdown: Equatable, Hashable { }

struct AdjustmentBreakdown {
  var liabilityForAdjustment: Adjustment
}
extension AdjustmentBreakdown: Equatable, Hashable { }
