//
//  BillStateModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

// TODO: Migrate to RW_BillModelTests et.al.
//final class BillStateModelTests: XCTestCase {
//  private var person1 = PersonModel(name: "GL")
//  private var person2 = PersonModel(name: "CN")
//  private var person3 = PersonModel(name: "TA")
//  private var person4 = PersonModel(name: "ZG")
//  private var person5 = PersonModel(name: "JW")
//
//
//
//
//  func testBillDivisionOfTwoItemsUnequallyDividedWithOverlap() {
//    let payers = [person1, person2, person3]
//
//    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, people: [person1, person2])
//    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount, people: [person2, person3])
//
//    let receipt = ReceiptModel(items: [item1, item2])
//    let billState = BillStateModel(people: payers, receipt: receipt)
//
//    let result = billState.splitBill
//
//
//    XCTAssertEqual(result.payees[person1]!.subtotalOwed, 1000.amount)
//
//    XCTAssertEqual(result.payees[person2]!.subtotalOwed, 1750.amount)
//
//    XCTAssertEqual(result.payees[person3]!.subtotalOwed, 749.amount)
//
//    XCTAssertEqual(result.leftoverAmount, .zero)
//    XCTAssertEqual(result.leftoverItems, .init())
//  }
//
//  func testBillDivisionWithNothingPaidFor() {
//    let payers = [person1, person2, person3]
//
//    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount)
//    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount)
//
//    let receipt = ReceiptModel(items: [item1, item2])
//    let billState = BillStateModel(people: payers, receipt: receipt)
//
//    let result = billState.splitBill
//
//    XCTAssertEqual(result.leftoverAmount, item2.itemCost + item1.itemCost)
//    XCTAssertFalse(result.leftoverItems.isEmpty)
//
//    XCTAssertEqual(result.payees[person1]?.subtotalOwed, 0.amount)
//    XCTAssertEqual(result.payees[person2]?.subtotalOwed, 0.amount)
//    XCTAssertEqual(result.payees[person3]?.subtotalOwed, 0.amount)
//  }
//
//  func testBillDivisionWithNotAllItemsPaidFor() {
//    let payers = [person1, person2, person3]
//
//    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, people: payers)
//    let item2 = ReceiptItemModel(itemName: "smoked salmon", itemCost: 1499.amount)
//
//    let receipt = ReceiptModel(items: [item1, item2])
//    let billState = BillStateModel(people: payers, receipt: receipt)
//
//    let result = billState.splitBill
//
//    XCTAssertEqual(result.leftoverAmount, item2.itemCost)
//
//    XCTAssertEqual(result.payees[person1]?.subtotalOwed, 667.amount)
//    XCTAssertEqual(result.payees[person2]?.subtotalOwed, 666.amount)
//    XCTAssertEqual(result.payees[person3]?.subtotalOwed, 667.amount)
//  }
//
//  func testBillDivisionWithPercentageAdjustmentDividingUnevenly() {
//    // each: 2000*(1 + 0.1815) / 3 == 787.6666666...
//    let payers = [person1, person2, person3]
//
//    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, people: payers)
//    let adj1 = ReceiptAdjustmentModel(name: "tip", adjustment: .percentage(18.15.percentage, .runningTotal))
//
//    let receipt = ReceiptModel(items: [item1], adjustments: [adj1])
//    let billState = BillStateModel(people: payers, receipt: receipt)
//
//    let result = billState.splitBill
//
//    XCTAssertEqual(result.payees[person1]?.subtotalOwed, 788.amount)
//    XCTAssertEqual(result.payees[person2]?.subtotalOwed, 787.amount)
//    XCTAssertEqual(result.payees[person3]?.subtotalOwed, 788.amount)
//  }
//
//  func testBillDivisionForRoundoffErrorWithHighPercentageAdjustment() {
//    // each: 2000*(1 + 195420)/3 == 130_160_666.666...
//    let payers = [person1, person2, person3]
//
//    let item1 = ReceiptItemModel(itemName: "swordfish", itemCost: 2000.amount, people: payers)
//    let adj1 = ReceiptAdjustmentModel(name: "tip", adjustment: .percentage(100.percentage, .runningTotal))
//
//    let receipt = ReceiptModel(items: [item1], adjustments: [adj1])
//    let billState = BillStateModel(people: payers, receipt: receipt)
//
//    let result = billState.splitBill
//
//    XCTAssertEqual(result.payees[person1]?.totalOwed, 1334.amount)
//    XCTAssertEqual(result.payees[person2]?.totalOwed, 1333.amount)
//    XCTAssertEqual(result.payees[person3]?.totalOwed, 1333.amount)
//  }
//}
