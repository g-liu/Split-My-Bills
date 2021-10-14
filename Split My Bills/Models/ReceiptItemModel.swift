//
//  ReceiptItemModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

/// Describes a single item on the receipt
struct ReceiptItemModel {
  /// Description of the item
  var itemName: String
  
  /// Cost of item
  var itemCost: Amount
  
  /// Tracks who is paying for the item
  var billees: Billees
  
  init(itemName: String, itemCost: Amount = .zero, people: [PersonModel]) {
    self.itemName = itemName
    self.itemCost = itemCost
    self.billees = Billees(people: people)
  }
  
  var formattedItemCost: String {
    itemCost.formatted
  }
  
}
extension ReceiptItemModel: Equatable, Hashable { }


struct Billees {
  private(set) var billees: [Billee]
  
  init(people: [PersonModel]) {
    self.billees = people.map { Billee(person: $0) }
  }
  
  var numberOfPayers: Int {
    billees.sum
  }
  
  var isSomeonePaying: Bool {
    billees.contains {
      switch $0.payingStatus {
        case .nonPaying: return false
        case .paying(amountOwed: _): return true
      }
    }
  }
  
  var isEveryonePaying: Bool {
    billees.allSatisfy { $0.payingStatus != .nonPaying }
  }
}
extension Billees: Equatable, Hashable { }

struct Billee {
  var person: PersonModel
  var payingStatus: PayStatus = .nonPaying
}
extension Billee: Equatable, Hashable { }

enum PayStatus {
  case nonPaying
  case paying(amountOwed: Int)
}
extension PayStatus: Equatable, Hashable { }
