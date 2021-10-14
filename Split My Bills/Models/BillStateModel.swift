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
  var splitBill: BillBreakdown {
    var billBreakdown = BillBreakdown(people: people)
    
    let remainderTracker = Payers(people: people)
    
    // STEP 1: Split the items
    
    receipt.items.forEach { item in
      billBreakdown.subtotalOfBill += item.itemCost
      
      guard item.billees.isSomeonePaying else {
        billBreakdown.leftoverItems.append(item)
        
        return
      }
      
      let (portion, remainder) = item.itemCost.portion(into: item.billees.billees.count)
      
      item.billees.billees.forEach { billee in
        billBreakdown.payees[billee.person]?.subtotalOwed += portion
      }
      
      if remainder > .zero {
        // TODO: Distribute the remainder according to least-remainder paid
      }
    }
    
    billBreakdown.computePayeesPortionOfTotal()
    
    // STEP 2: Split the adjustments
    receipt.adjustments.forEach { adjustment in
      var runningRemainder: Double = 0
      
      switch adjustment.adjustment {
        case .amount(let amount):
          billBreakdown.payees.forEach { person, payee in
            let quotient = amount * payee.percentOfTotalBill
            let remainder = amount % payee.percentOfTotalBill
            
            billBreakdown.payees[person]?.adjustmentsOwed += quotient
            
            runningRemainder += remainder
          }
        case .percentage(let percentage, let applicablePortion):
          // convert percentage adjustment to dollar amount
          let equivalentAmount: Amount

          switch applicablePortion {
            case .runningTotal:
              equivalentAmount = billBreakdown.runningTotal * percentage
            case .subtotal:
              equivalentAmount = billBreakdown.subtotalOfBill * percentage
          }

          // TODO: REMOVE DUPLICATE CODE!!!!!!!!!!!!!!!!!!!!!!!!!
          billBreakdown.payees.forEach { person, payee in
            let quotient = equivalentAmount * payee.percentOfTotalBill
            let remainder = equivalentAmount % payee.percentOfTotalBill
            
            billBreakdown.payees[person]?.adjustmentsOwed += quotient
            
            runningRemainder += remainder
          }
      }
      
      if runningRemainder > .zero {
        // TODO: Distribute the remainders by running (from subtotal) least remainders owned, in initial order
      }
    }

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
//            billByPerson.payees[person]?.totalOwed += adjustmentPortions.portion
//            billByPerson.payees[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: Adjustment.amount(adjustmentPortions.portion))
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
//            billByPerson.payees[person]?.totalOwed += adjustmentPortions.portion
//            billByPerson.payees[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: adjustment.adjustment)
//          }
//      }
//    }

    return billBreakdown
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
