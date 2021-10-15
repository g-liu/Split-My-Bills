//
//  BillBreakdownModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct BillBreakdownModel {
  var perPersonItemsBreakdown: [PersonModel: ItemsBreakdown] = [:]
  var perPersonAdjustmentsBreakdown: [PersonModel: AdjustmentsBreakdown] = [:]
  
  var unclaimedItems: [ReceiptItem] = []
  
  init(persons: [PersonModel]) {
    persons.forEach { person in
      perPersonItemsBreakdown[person] = .init()
      perPersonAdjustmentsBreakdown[person] = .init()
    }
  }
  
  var perPersonGrandTotals: [PersonModel: Amount] {
    let result = perPersonItemsBreakdown.map { person, itemBreakdown -> (PersonModel, Amount) in
      return (person, itemBreakdown.subtotalToPayer + (perPersonAdjustmentsBreakdown[person]?.adjustmentsTotal ?? .zero))
    }
    
    return Dictionary(uniqueKeysWithValues: result)
  }
}
