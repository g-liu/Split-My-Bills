//
//  BillByPerson.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

// TODO: MAY NOT NEED THIS ANYMORE
struct BillByPerson {
  var billLiabilities: [PersonModel: BillLiability] /* TODO: Could be derived from Receipt model and this file gotten rid of (except for leftover) */
  var leftoverItems: [ReceiptItemModel]
  
  var leftoverAmount: Amount {
    leftoverItems.reduce(Amount.zero) {
      $0 + $1.itemCost
    }
  }
  
  init(people: [PersonModel]) {
    leftoverItems = []
    self.billLiabilities = people.reduce([:], { (result, personModel) -> [PersonModel: BillLiability] in
      // TODO: There has to be a better way to init.
      var dict = result
      dict[personModel] = BillLiability()
      return dict
    })
  }
}

struct BillLiability {
  var totalOwed: Amount = .zero
}
extension BillLiability: Equatable, Hashable { }
