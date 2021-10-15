//
//  BillBreakdownModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

struct BillBreakdownModel {
  private var perPersonItemsBreakdown: [PersonModel: ItemsBreakdown] = [:]
  private var perPersonAdjustmentsBreakdown: [PersonModel: AdjustmentsBreakdown] = [:]
  
  private(set) var unclaimedItems: [ReceiptItem] = []
  
  init(persons: [PersonModel]) {
    persons.forEach { person in
      perPersonItemsBreakdown[person] = .init()
      perPersonAdjustmentsBreakdown[person] = .init()
    }
  }
  
  // MARK: Getters
  
  func getItemCost(person: PersonModel, itemIndex: Int) -> Amount? {
    return perPersonItemsBreakdown[person]?.itemsBreakdown[itemIndex].costToPayer
  }
  
  func getAdjustmentCost(person: PersonModel, adjustmentIndex: Int) -> Amount? {
    return perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown[adjustmentIndex].costEquivalentToPayer
  }
  
  func getSubtotal(person: PersonModel) -> Amount? {
    return perPersonItemsBreakdown[person]?.subtotalToPayer
  }
  
  func getPercentageOfSubtotal(person: PersonModel) -> Percentage? {
    return perPersonItemsBreakdown[person]?.percentageOfSubtotal
  }
  
  func getGrandTotal(person: PersonModel) -> Amount? {
    (perPersonItemsBreakdown[person]?.subtotalToPayer ?? .zero) +
    (perPersonAdjustmentsBreakdown[person]?.adjustmentsTotal ?? .zero)
  }
  
  // MARK: Setters
  
  mutating func addItemBreakdown(person: PersonModel, breakdown: ItemBreakdown) {
    perPersonItemsBreakdown[person]?.itemsBreakdown.append(breakdown)
  }
  
  mutating func addAdjustmentBreakdown(person: PersonModel, breakdown: AdjustmentBreakdown) {
    perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown.append(breakdown)
  }
  
  @discardableResult
  mutating func amendLastItemBreakdown(person: PersonModel, by amount: Amount) -> Bool {
    if let itemBreakdownCount = perPersonItemsBreakdown[person]?.itemsBreakdown.count {
      let lastItemIndex = itemBreakdownCount - 1
      perPersonItemsBreakdown[person]?.itemsBreakdown[lastItemIndex].costToPayer += amount
      return true
    } else {
      return false
    }
  }
  
  @discardableResult
  mutating func amendLastAdjustmentBreakdown(person: PersonModel, by amount: Amount) -> Bool {
    if let adjustmentBreakdownCount = perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown.count {
      let lastItemIndex = adjustmentBreakdownCount - 1
      perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown[lastItemIndex].costEquivalentToPayer += amount
      return true
    } else {
      return false
    }
  }
  
  mutating func addUnclaimedItem(_ item: ReceiptItem) {
    unclaimedItems.append(item)
  }
}
