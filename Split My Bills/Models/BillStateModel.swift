//
//  BillStateModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation
import SwiftPriorityQueue

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
  var splitBill: BillByPerson {
    var billByPerson = BillByPerson(payers: payers)
    
//    let remainderTracker = PriorityQueue(ascending: true, startingValues: payers.map( { RemainderPayer(person: $0) }))
    let remainderTracker = payers.map { RemainderPayer.init(person: $0) }

    var runningTotal: Amount = .zero
    var runningRemainder: Amount = .zero
    
    // STEP 1: Split the items
    
    receipt.items.forEach { item in
      runningTotal += item.itemCost
      guard !item.payers.isEmpty else {
        billByPerson.leftoverItems.itemsBreakdown[item] = ItemBreakdown(splitCount: 0, liabilityForItem: item.itemCost)
        
        return
      }
      
      let portions = item.itemCost.portion(into: item.payers.count)
      runningRemainder += portions.remainder
      
      item.payers.forEach { person in
        billByPerson.billLiabilities[person]?.totalOwed += portions.portion
        billByPerson.billLiabilities[person]?.itemsBreakdown[item] = ItemBreakdown(splitCount: item.payers.count, liabilityForItem: portions.portion)
      }
    }
    
    let subtotal = runningTotal
    
    // STEP 2: Split the adjustments

    receipt.adjustments.forEach { adjustment in
      
      switch adjustment.adjustment {
        case .amount(let adjustmentAmount):
          runningTotal = runningTotal.adjusted(by: adjustment.adjustment)
          let adjustmentPortions = adjustmentAmount.portion(into: payers.count)
          
          runningRemainder += adjustmentPortions.remainder
          
          payers.forEach { person in
            billByPerson.billLiabilities[person]?.totalOwed += adjustmentPortions.portion
            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: Adjustment.amount(adjustmentPortions.portion))
          }
        case .percentage(let percentage, let applicablePortion):
          let equivalentAmount: Amount
          
          switch applicablePortion {
            case .runningTotal:
              equivalentAmount = runningTotal * percentage // TODO: CHECK FOR ROUNDOFF
            case .subtotal:
              equivalentAmount = subtotal * percentage // TODO: ALSO CHECK FOR ROUNDOFF
          }
          
          runningTotal = runningTotal + equivalentAmount
          let adjustmentPortions = equivalentAmount.portion(into: payers.count)
          
          runningRemainder += adjustmentPortions.remainder
          
          payers.enumerated().forEach { index, person in
            billByPerson.billLiabilities[person]?.totalOwed += adjustmentPortions.portion
            billByPerson.billLiabilities[person]?.adjustmentsBreakdown[adjustment] = AdjustmentBreakdown(liabilityForAdjustment: adjustment.adjustment)
          }
      }
    }
    
    // STEP 3: Split the remainder amount as evenly as possible
    runningRemainder.splitPortion(into: payers.count).enumerated().forEach { index, amount in
      let person = payers[index]
      billByPerson.billLiabilities[person]?.totalOwed += amount
    }

    return billByPerson
  }
}

private struct RemainderTracker {
  // TODO: Test plain array vs. pq implementation.
}

private struct RemainderPayer: Comparable {
  var person: PersonModel
  var totalRemainderPaid: Amount = .zero
  
  static func < (lhs: RemainderPayer, rhs: RemainderPayer) -> Bool {
    if lhs.totalRemainderPaid == rhs.totalRemainderPaid {
      return lhs.person < rhs.person
    }
    
    return lhs.totalRemainderPaid < rhs.totalRemainderPaid
  }
}
