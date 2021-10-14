//
//  BillBreakdown.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

// TODO: MAY NOT NEED THIS ANYMORE
struct BillBreakdown {
  var payees: [PersonModel: PayeeBreakdown] /* TODO: Could be derived from Receipt model and this file gotten rid of (except for leftover)???? */
  var leftoverItems: [ReceiptItemModel]
  
  var subtotalOfBill: Amount = .zero
  var adjustmentTotal: Amount = .zero // TODO: Could these be handled on ReceiptModel instead?
  // Need to re-look at model responsibilities.
  
  var runningTotal: Amount { subtotalOfBill + adjustmentTotal }
  
  var leftoverAmount: Amount {
    leftoverItems.reduce(Amount.zero) {
      $0 + $1.itemCost
    }
  }
  
  init(people: [PersonModel]) {
    leftoverItems = []
    self.payees = people.reduce([:], { (result, personModel) -> [PersonModel: PayeeBreakdown] in
      // TODO: There has to be a better way to init.
      var dict = result
      dict[personModel] = PayeeBreakdown()
      return dict
    })
  }
  
  mutating func computePayeesPortionOfTotal() {
    payees.forEach { payees[$0.key]?.computePortion(of: subtotalOfBill) }
  }
}

struct PayeeBreakdown {
  var subtotalOwed: Amount = .zero
  var adjustmentsOwed: Amount = .zero
  var percentOfTotalBill: Percentage = .zero
  
  mutating func computePortion(of subtotal: Amount) {
    // TODO: CHECK FOR DIVIDE BY ZERO!!!!!
    percentOfTotalBill = subtotalOwed / subtotal
  }
}
extension PayeeBreakdown: Equatable, Hashable { }
