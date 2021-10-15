//
//  BillModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation
import XCTest
@testable import Split_My_Bills

final class BillModelTests: XCTestCase {
  private let person1 = PersonModel(name: "CN")
  private let person2 = PersonModel(name: "GL")
  private let person3 = PersonModel(name: "JW")
  private let person4 = PersonModel(name: "TA")
  private let person5 = PersonModel(name: "ZG")
  
  private var possiblePeople: [PersonModel] = []
  
  override func setUp() {
    possiblePeople = [person1, person2, person3, person4, person5]
  }
  
  func testBillDivisionOfEmptyBill() {
    let billState = makeBill(numPeople: 2)
    let result = billState.splitBill

    VerifySubtotals(result, [0,0].amount)
  }
  
  func testBillSplitSingleDivisibleItem() {
    let bill = makeBill(numPeople: 3, itemsMeta: [(1500.amount, [true,true,true])])
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPersonItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown.count, 3)
    
    VerifySubtotals(result, [500,500,500].amount)
    
    VerifyItemBreakdowns(result, itemMeta: [[500,500,500].amount])
  }
  
  func testBillDivisionOfSingleItemNonDivisibleCostBill() {
    let billState = makeBill(numPeople: 3, itemsMeta: [(50.amount,[true,true,true])])

    let result = billState.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 17.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 17.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 16.amount)

    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillDivisionOfTwoItemsUnequallyDividedNoOverlap() {
    let billModel = makeBill(numPeople: 4,
                             itemsMeta: [(2000.amount,[true,false,false,true]),
                                         (1499.amount,[false,true,true,false])])

    let result = billModel.splitBill
    
    VerifySubtotals(result, [1000,750,749,1000].amount)
    VerifyItemBreakdowns(result, itemMeta: [[1000,0,0,1000],
                                            [0,750,749,0]].amount)
    
    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillDivisionOfTwoItemsUnequallyDividedWithOverlap() {
    let billModel = makeBill(numPeople: 3,
                             itemsMeta: [(2001.amount,[true,true,false]),
                                        (1499.amount,[false,true,true])])
    
    let result = billModel.splitBill
    
    VerifySubtotals(result, [1001,1749,750].amount)
    VerifyItemBreakdowns(result, itemMeta: [[1001,1000,0],
                                            [0,749,750]].amount)
    
    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillSplitMultipleDivisibleItems() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(1500.amount,[true,true,true]),
                                    (2442.amount,[true,true,true])])
    let result = bill.splitBill
    
    VerifySubtotals(result, [1314,1314,1314].amount)
    VerifyItemBreakdowns(result, itemMeta: [[500,500,500],
                                            [814,814,814]].amount)
  }
  
  func testBillUnevenlySplitMultipleDivisbleItems() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(2500.amount,[true,false,true]),
                                    (2445.amount,[true,true,true]),
                                    (776.amount,[false,true,true])])
    let result = bill.splitBill
    
    VerifySubtotals(result, [2065,1203,2453].amount)
    VerifyItemBreakdowns(result, itemMeta: [[1250,0,1250],
                                            [815,815,815],
                                            [0,388,388]].amount)
  }
  
  func testBillSplitSingleDivisibleItemWithDivisibleAdjustment() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(1500.amount,[true,true,true])],
                        adjustmentsMeta: [.percentage(15.percentage, .runningTotal)])
    let result = bill.splitBill
    
    VerifySubtotals(result, [500,500,500].amount)
    VerifyItemBreakdowns(result, itemMeta: [[500,500,500]].amount)
    VerifyAdjustmentBreakdowns(result, adjustmentMeta: [[75,75,75]].amount)
    VerifyGrandTotals(result, [575,575,575].amount)
  }
  
  // - MARK: Test precondition helpers
  
  private func makeBill(numPeople: Int, itemsMeta: [(Amount, [Bool])] = [], adjustmentsMeta: [Adjustment] = []) -> BillModel {
    // Step 1: Generate names in alphabetical order
    // For now, just pick from the preset list
    // TODO: Make it possible to generate arbitrarily many people names in alpha. order
    let people = getArrayOfPeople(numPeople)
    
    let items = itemsMeta.enumerated().map { index, meta in
      ReceiptItem(itemName: "item\(index)", itemCost: meta.0, isBillableToPayer: meta.1)
    }
    
    let adjustments = adjustmentsMeta.enumerated().map { index, meta in
      ReceiptAdjustment(adjustmentName: "adj\(index)", adjustment: meta)
    }
    
    return BillModel(persons: people, items: items, adjustments: adjustments)
  }
  
  private func getArrayOfPeople(_ count: Int) -> [PersonModel] {
    let constrainedCount = Int(min(possiblePeople.count, max(0, count)))
    return Array(possiblePeople[0..<constrainedCount])
  }
  
  // - MARK: Test verification helpers
  
  private func VerifySubtotals(_ result: BillBreakdownModel, _ subtotals: [Amount]) {
    let people = getArrayOfPeople(subtotals.count)
    
    people.enumerated().forEach { index, person in
      XCTAssertEqual(result.perPersonItemsBreakdown[person]?.subtotalToPayer, subtotals[index],
                     "Wrong subtotal for \(person)'s breakdown, expected \(subtotals[index])")
    }
  }
  
  private func VerifyItemBreakdowns(_ result: BillBreakdownModel, itemMeta: [[Amount]]) {
    itemMeta.enumerated().forEach { itemIndex, itemsInRow in
      itemsInRow.enumerated().forEach { personIndex, amount in
        let person = possiblePeople[personIndex]
        XCTAssertEqual(result.perPersonItemsBreakdown[person]?.itemsBreakdown[itemIndex].costToPayer, amount,
                       "Wrong amount for \(person)'s portion of item# \(itemIndex); expected \(amount)")
      }
    }
  }
  
  private func VerifyAdjustmentBreakdowns(_ result: BillBreakdownModel, adjustmentMeta: [[Amount]]) {
    adjustmentMeta.enumerated().forEach { adjustmentIndex, adjustmentsInRow in
      adjustmentsInRow.enumerated().forEach { personIndex, amount in
        let person = possiblePeople[personIndex]
        XCTAssertEqual(result.perPersonAdjustmentsBreakdown[person]?.adjustmentsBreakdown[adjustmentIndex].costEquivalentToPayer, amount,
                       "Wrong amount for \(person)'s portion of adjustment# \(adjustmentIndex); expected \(amount)")
      }
    }
  }
  
  private func VerifyGrandTotals(_ result: BillBreakdownModel, _ grandTotals: [Amount]) {
    let people = getArrayOfPeople(grandTotals.count)
    
    people.enumerated().forEach { index, person in
      XCTAssertEqual(result.perPersonGrandTotals[person], grandTotals[index],
                     "Wrong grand total for \(person)'s breakdown, expected \(grandTotals[index])")
    }
  }
}

private extension Array where Element == Int {
  var amount: [Amount] {
    map { $0.amount }
  }
}

private extension Array where Element == [Int] {
  var amount: [[Amount]] {
    map { $0.amount }
  }
}
