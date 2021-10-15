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
  
  func testBillDivisionOfEmptyBill() {
    let billState = makeBill(numPeople: 2)
    let result = billState.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, .zero)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, .zero)
  }
  
  func testBillSplitSingleDivisibleItem() {
    let bill = makeBill(numPeople: 3, itemsMeta: [(1500.amount, [true,true,true])])
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPersonItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 500.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown.first?.costToPayer, 500.amount)
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
                                        (1499.amount,[false,true,true,false]),])

    let result = billModel.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 1000.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 750.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 749.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person4]?.subtotalToPayer, 1000.amount)

    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillDivisionOfTwoItemsUnequallyDividedWithOverlap() {
    let billModel = makeBill(numPeople: 3,
                             itemsMeta: [(2001.amount,[true,true,false]),
                                        (1499.amount,[false,true,true]),])
    
    let result = billModel.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 1001.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 1749.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 750.amount)
    
    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillSplitMultipleDivisibleItems() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(1500.amount,[true,true,true]),
                                   (2442.amount,[true,true,true])])
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 1314.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 1314.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 1314.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown[1].costToPayer, 814.amount)
  }
  
  func testBillUnevenlySplitMultipleDivisbleItems() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(2500.amount,[true,false,true]),
                                   (2445.amount,[true,true,true]),
                                   (776.amount,[false,true,true])])
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 2065.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 1203.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 2453.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown.first?.costToPayer, 0.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown[1].costToPayer, 815.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown[2].costToPayer, 0.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown[2].costToPayer, 388.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown[2].costToPayer, 388.amount)
  }
  
  func testBillSplitSingleDivisibleItemWithDivisibleAdjustment() {
    let bill = makeBill(numPeople: 3,
                        itemsMeta: [(1500.amount,[true,true,true])],
                        adjustmentsMeta: [.percentage(15.percentage, .runningTotal)])
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPersonItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPersonGrandTotals[person1], 575.amount)
    XCTAssertEqual(result.perPersonGrandTotals[person2], 575.amount)
    XCTAssertEqual(result.perPersonGrandTotals[person3], 575.amount)
    
    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown[person1]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown[person2]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPersonAdjustmentsBreakdown[person3]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
  }
  
  private func makeBill(numPeople: Int, itemsMeta: [(Amount, [Bool])] = [], adjustmentsMeta: [Adjustment] = []) -> BillModel {
    // Step 1: Generate names in alphabetical order
    // For now, just pick from the preset list
    // TODO: Make it possible to generate arbitrarily many people names in alpha. order
    let possiblePeople = [person1, person2, person3, person4, person5]
    let constrainedNumPeople = Int(min(5, max(0, numPeople)))
    let people = Array(possiblePeople[0..<constrainedNumPeople])
    
    let items = itemsMeta.enumerated().map { index, meta in
      ReceiptItem(itemName: "item\(index)", itemCost: meta.0, isBillableToPayer: meta.1)
    }
    
    let adjustments = adjustmentsMeta.enumerated().map { index, meta in
      ReceiptAdjustment(adjustmentName: "adj\(index)", adjustment: meta)
    }
    
    return BillModel(persons: people, items: items, adjustments: adjustments)
  }
}
