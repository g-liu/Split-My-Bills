//
//  BillStateModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation
import SwiftPriorityQueue

// Ties together everything needed to split a single bill.
struct BillStateModel {
  var people: [PersonModel] // TODO Make this let? otherwise risk of decoupling b/t here and ReceiptItemModel 😱
  
  var receipt: ReceiptModel
  
  init(people: [PersonModel] = [], receipt: ReceiptModel = .init()) {
    self.people = people
    self.receipt = receipt
  }
  
  var peopleAsList: String {
    people.reduce("") { (result, model) -> String in
      result + "\n" + model.name
    }
  }
  
  /// Calculates the amount owed by each person
  var splitBill: BillByPerson {
    var billByPerson = BillByPerson(people: people)
    
    let remainderTracker = Payers(people: people)

    var runningTotal: Amount = .zero
    
    // STEP 1: Split the items
    
    receipt.items.forEach { item in
      runningTotal += item.itemCost
      
      guard item.billees.isSomeonePaying else {
        billByPerson.leftoverItems.append(item)
        
        return
      }
      
      let (portion, remainder) = item.itemCost.portion(into: item.billees.billees.count)
      
      item.billees.billees.forEach { billee in
        billByPerson.billLiabilities[billee.person]?.totalOwed += portion
      }
      
      if remainder > .zero {
        // TODO: Distribute the remainder according to least-remainder paid
      }
    }
    
    let subtotal = runningTotal
    
    // STEP 2: Split the adjustments

    // TODO: NO!!! This code is invalid. No adjustments should be split evenly. They should be split according to the portion of the bill each payee is responsible for.
//    receipt.adjustments.forEach { adjustment in
//      switch adjustment.adjustment {
//        case .amount(let adjustmentAmount):
//          runningTotal = runningTotal.adjusted(by: adjustment.adjustment)
//          let adjustmentPortions = adjustmentAmount.portion(into: payers.count)
//
//          runningRemainder += adjustmentPortions.remainder
//
//          payers.forEach { person in
//            billByPerson.billLiabilities[person]?.totalOwed += adjustmentPortions.portion
//            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: Adjustment.amount(adjustmentPortions.portion))
//          }
//        case .percentage(let percentage, let applicablePortion):
//          let equivalentAmount: Amount
//
//          switch applicablePortion {
//            case .runningTotal:
//              equivalentAmount = runningTotal * percentage // TODO: CHECK FOR ROUNDOFF
//            case .subtotal:
//              equivalentAmount = subtotal * percentage // TODO: ALSO CHECK FOR ROUNDOFF
//          }
//
//          runningTotal = runningTotal + equivalentAmount
//          let adjustmentPortions = equivalentAmount.portion(into: payers.count)
//
//          runningRemainder += adjustmentPortions.remainder
//
//          payers.enumerated().forEach { index, person in
//            billByPerson.billLiabilities[person]?.totalOwed += adjustmentPortions.portion
//            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: adjustment.adjustment)
//          }
//      }
//    }

    return billByPerson
  }
}

struct Payers {
  var payers: [Payer]
  
  init(people: [PersonModel]) {
    payers = people.map { Payer(person: $0) }
  }
}

struct Payer {
  private(set) var person: PersonModel
  var numRemaindersPaid: Int
  
  init(person: PersonModel, numRemaindersPaid: Int = 0) {
    self.person = person
    self.numRemaindersPaid = numRemaindersPaid
  }
}
