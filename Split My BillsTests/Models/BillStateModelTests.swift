//
//  BillStateModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class BillStateModelTests: XCTestCase {
  private var person1 = PersonModel(name: "GL")
  private var person2 = PersonModel(name: "CN")
  private var person3 = PersonModel(name: "TA")
  private var person4 = PersonModel(name: "ZG")
  private var person5 = PersonModel(name: "JW")
  
  /* TODO: REWRITE ALL TEST CASES AFTER MAJOR REFACTOR!!!!!!!!!!!!! */
  
  func testBareZeroCase() {
    let billState = BillStateModel()
    
    XCTAssert(billState.splitBill.billLiabilities.isEmpty)
  }
  
  func testBillDivisionOfEmptyBill() {
    let payers = [person1, person2]
    
    let billState = BillStateModel(payers: payers, receipt: .init())
    let result = billState.splitBill
    
    XCTAssertEqual(result.billLiabilities[person1]!.totalOwed, .zero)
    XCTAssertEqual(result.billLiabilities[person2]!.totalOwed, .zero)
  }
  
  func testBillDivisionOfSingleItemDivisibleCostBill() {
    let payers = [person1, person2, person3, person4, person5]
    
    let item = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, payers: payers)
    let receipt = ReceiptModel(items: [item])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    XCTAssertEqual(result.billLiabilities[person1]!.totalOwed, 400.amount)
    XCTAssertEqual(result.billLiabilities[person2]!.totalOwed, 400.amount)
    XCTAssertEqual(result.billLiabilities[person3]!.totalOwed, 400.amount)
    XCTAssertEqual(result.billLiabilities[person4]!.totalOwed, 400.amount)
    XCTAssertEqual(result.billLiabilities[person5]!.totalOwed, 400.amount)
    
    XCTAssertEqual(result.leftoverAmount, .zero)
    XCTAssertEqual(result.leftoverItems, .init())
  }
  
  func testBillDivisionOfSingleItemNonDivisibleCostBill() {
    let payers = [person1, person2, person3]
    
    let item = ReceiptItemModel(itemName: "token", itemCost: 50.amount, payers: payers)
    let receipt = ReceiptModel(items: [item])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    let person1ItemsBreakdown = [
      item: ItemBreakdown(splitCount: 3, liabilityForItem: 17.amount),
    ]
    
    let person2ItemsBreakdown = [
      item: ItemBreakdown(splitCount: 3, liabilityForItem: 16.amount),
    ]
    
    let person3ItemsBreakdown = [
      item: ItemBreakdown(splitCount: 3, liabilityForItem: 17.amount),
    ]
    
    XCTAssertEqual(result.billLiabilities[person1]!.totalOwed, 17.amount)
    XCTAssertEqual(result.billLiabilities[person1]!.itemsBreakdown, person1ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person2]!.totalOwed, 16.amount)
    XCTAssertEqual(result.billLiabilities[person2]!.itemsBreakdown, person2ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person3]!.totalOwed, 17.amount)
    XCTAssertEqual(result.billLiabilities[person3]!.itemsBreakdown, person3ItemsBreakdown)
    
    XCTAssertEqual(result.leftoverAmount, .zero)
    XCTAssertEqual(result.leftoverItems, .init())
  }
  
  func testBillDivisionOfTwoItemsUnequallyDividedNoOverlap() {
    let payers = [person1, person2, person3, person4]
    
    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, payers: [person1, person4])
    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount, payers: [person2, person3])
    
    let receipt = ReceiptModel(items: [item1, item2])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    let person1ItemsBreakdown = [
      item1: ItemBreakdown(splitCount: 2, liabilityForItem: 1000.amount),
    ]
    
    let person2ItemsBreakdown = [
      item2: ItemBreakdown(splitCount: 2, liabilityForItem: 750.amount),
    ]
    
    let person3ItemsBreakdown = [
      item2: ItemBreakdown(splitCount: 2, liabilityForItem: 749.amount),
    ]
    
    let person4ItemsBreakdown = [
      item1: ItemBreakdown(splitCount: 2, liabilityForItem: 1000.amount),
    ]
    
    XCTAssertEqual(result.billLiabilities[person1]!.totalOwed, 1000.amount)
    XCTAssertEqual(result.billLiabilities[person1]!.itemsBreakdown, person1ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person2]!.totalOwed, 750.amount)
    XCTAssertEqual(result.billLiabilities[person2]!.itemsBreakdown, person2ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person3]!.totalOwed, 749.amount)
    XCTAssertEqual(result.billLiabilities[person3]!.itemsBreakdown, person3ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person4]!.totalOwed, 1000.amount)
    XCTAssertEqual(result.billLiabilities[person4]!.itemsBreakdown, person4ItemsBreakdown)
    
    XCTAssertEqual(result.leftoverAmount, .zero)
    XCTAssertEqual(result.leftoverItems, .init())
  }
  
  func testBillDivisionOfTwoItemsUnequallyDividedWithOverlap() {
    let payers = [person1, person2, person3]
    
    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, payers: [person1, person2])
    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount, payers: [person2, person3])
    
    let receipt = ReceiptModel(items: [item1, item2])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    let person1ItemsBreakdown = [
      item1: ItemBreakdown(splitCount: 2, liabilityForItem: 1000.amount),
    ]
    
    let person2ItemsBreakdown = [
      item1: ItemBreakdown(splitCount: 2, liabilityForItem: 1000.amount),
      item2: ItemBreakdown(splitCount: 2, liabilityForItem: 750.amount),
    ]
    
    let person3ItemsBreakdown = [
      item2: ItemBreakdown(splitCount: 2, liabilityForItem: 749.amount),
    ]
    
    XCTAssertEqual(result.billLiabilities[person1]!.totalOwed, 1000.amount)
    XCTAssertEqual(result.billLiabilities[person1]!.itemsBreakdown, person1ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person2]!.totalOwed, 1750.amount)
    XCTAssertEqual(result.billLiabilities[person2]!.itemsBreakdown, person2ItemsBreakdown)
    
    XCTAssertEqual(result.billLiabilities[person3]!.totalOwed, 749.amount)
    XCTAssertEqual(result.billLiabilities[person3]!.itemsBreakdown, person3ItemsBreakdown)
    
    XCTAssertEqual(result.leftoverAmount, .zero)
    XCTAssertEqual(result.leftoverItems, .init())
  }
  
  func testBillDivisionWithNothingPaidFor() {
    let payers = [person1, person2, person3]
    
    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount)
    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount)
    
    let receipt = ReceiptModel(items: [item1, item2])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    XCTAssertEqual(result.leftoverAmount, item2.itemCost + item1.itemCost)
    XCTAssertNotNil(result.leftoverItems.itemsBreakdown[item2])
    XCTAssertNotNil(result.leftoverItems.itemsBreakdown[item1])
    
    XCTAssertEqual(result.billLiabilities[person1]?.totalOwed, 0.amount)
    XCTAssertEqual(result.billLiabilities[person2]?.totalOwed, 0.amount)
    XCTAssertEqual(result.billLiabilities[person3]?.totalOwed, 0.amount)
  }
  
  func testBillDivisionWithNotAllItemsPaidFor() {
    let payers = [person1, person2, person3]
    
    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, payers: payers)
    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount)
    
    let receipt = ReceiptModel(items: [item1, item2])
    let billState = BillStateModel(payers: payers, receipt: receipt)
    
    let result = billState.splitBill
    
    XCTAssertEqual(result.leftoverAmount, item2.itemCost)
    XCTAssertNotNil(result.leftoverItems.itemsBreakdown[item2])
    
    XCTAssertEqual(result.billLiabilities[person1]?.totalOwed, 667.amount)
    XCTAssertEqual(result.billLiabilities[person2]?.totalOwed, 666.amount)
    XCTAssertEqual(result.billLiabilities[person3]?.totalOwed, 667.amount)
  }
}
