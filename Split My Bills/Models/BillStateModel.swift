//
//  BillStateModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

struct BillStateModel {
  var payers: [PersonModel]
  
  var receipt: ReceiptModel
  
  init(payers: [PersonModel] = [], receipt: ReceiptModel = .init()) {
    self.payers = payers
    self.receipt = receipt
  }
  
  var payersAsList: String {
    payers.reduce("") { (result, model) -> String in
      result + "\n" + model.name
    }
  }
  
  /// Calculates the amount owed by each person
  // TODO IMPLEMENT
  var splitBill: BillByPerson {
    var billByPerson = BillByPerson(payers: payers)

    receipt.items.forEach { item in
      guard !item.payers.isEmpty else {
        billByPerson.leftoverItems.itemsBreakdown[item] = ItemBreakdown(splitCount: 0, liabilityForItem: item.itemCost)
        
        return
      }
      
      let portions = item.itemCost.portion(into: item.payers.count)
      
      item.payers.enumerated().forEach { index, person in
        billByPerson.billLiabilities[person]?.totalOwed += portions[index]
        billByPerson.billLiabilities[person]?.itemsBreakdown[item] = ItemBreakdown(splitCount: item.payers.count, liabilityForItem: portions[index])
      }
    }

    receipt.adjustments.forEach { adjustment in
      switch adjustment.adjustment {
        case .amount(let amount):
          let portions = amount.portion(into: payers.count)
          payers.enumerated().forEach { index, person in
            billByPerson.billLiabilities[person]?.totalOwed += portions[index]
            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: Adjustment.amount(portions[index]))
          }
        case .percentage(let percentage):
          // TODO VERIFY MATH ON THIS ESP. WITH ROUNDING ERROR!
          let portionPerPayer = percentage / payers.count
          payers.forEach { person in
            billByPerson.billLiabilities[person]?.totalOwed *= portionPerPayer
            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: Adjustment.percentage(portionPerPayer))
          }
      }
      
    }

    return billByPerson
  }
}
