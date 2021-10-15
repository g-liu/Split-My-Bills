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
  private let person1 = PersonModel(name: "GL")
  private let person2 = PersonModel(name: "CN")
  private let person3 = PersonModel(name: "TA")
  private let person4 = PersonModel(name: "ZG")
  private let person5 = PersonModel(name: "JW")
  
  func testBillDivisionOfEmptyBill() {
    let persons = [person1, person2]

    let billState = BillModel(persons: persons)
    let result = billState.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, .zero)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, .zero)
  }
  
  func testBillSplitSingleDivisibleItem() {
    let persons = [person1, person2, person3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let bill = BillModel(persons: persons, items: items)
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
    let persons = [person1, person2, person3]

    let item = ReceiptItem(itemName: "heh", itemCost: 50.amount, isBillableToPayer: [true, true, true])
    let billState = BillModel(persons: persons, items: [item])

    let result = billState.splitBill

    XCTAssertEqual(result.perPersonItemsBreakdown[person1]?.subtotalToPayer, 17.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person2]?.subtotalToPayer, 17.amount)
    XCTAssertEqual(result.perPersonItemsBreakdown[person3]?.subtotalToPayer, 16.amount)

    XCTAssert(result.unclaimedItems.isEmpty)
  }
  
  func testBillSplitMultipleDivisibleItems() {
    let persons = [person1, person2, person3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
      .init(itemName: "J2", itemCost: 2442.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let bill = BillModel(persons: persons, items: items)
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
    let persons = [person1, person2, person3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 2500.amount, isBillableToPayer: [true,false,true]), // 1250 per
      .init(itemName: "J2", itemCost: 2445.amount, isBillableToPayer: [true,true,true]), // 815 per
      .init(itemName: "J3", itemCost: 776.amount, isBillableToPayer: [false,true,true]), // 388 per
    ]
    
    let bill = BillModel(persons: persons, items: items)
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
    let persons = [person1, person2, person3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let adjustments: [ReceiptAdjustment] = [
      .init(adjustmentName: "tax", adjustment: .percentage(15.percentage, .runningTotal))
    ]
    
    let bill = BillModel(persons: persons, items: items, adjustments: adjustments)
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
}
