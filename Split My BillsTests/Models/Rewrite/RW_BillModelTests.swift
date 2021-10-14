//
//  RW_BillModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation
import XCTest
@testable import Split_My_Bills

final class RW_BillModelTests: XCTestCase {
  
  func testBillSplitSingleDivisibleItem() {
    let people: [PersonModel] = ["GL", "AB", "CD"].map { PersonModel(name: $0) }
    let payers: [PayerModel] = people.map { PayerModel(person: $0) }
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, whoIsPaying: [true,true,true]),
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsSubtotal, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsSubtotal, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsSubtotal, 500.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown.first?.costToPayer, 500.amount)
  }
  
  func testBillSplitMultipleDivisibleItems() {
    let people: [PersonModel] = ["GL", "AB", "CD"].map { PersonModel(name: $0) }
    let payers: [PayerModel] = people.map { PayerModel(person: $0) }
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, whoIsPaying: [true,true,true]),
      .init(itemName: "J2", itemCost: 2442.amount, whoIsPaying: [true,true,true]),
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsSubtotal, 1314.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsSubtotal, 1314.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsSubtotal, 1314.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown[1].costToPayer, 814.amount)
  }
  
  func testBillUnevenlySplitMultipleDivisbleItems() {
    let people: [PersonModel] = ["GL", "AB", "CD"].map { PersonModel(name: $0) }
    let payers: [PayerModel] = people.map { PayerModel(person: $0) }
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 2500.amount, whoIsPaying: [true,false,true]), // 1250 per
      .init(itemName: "J2", itemCost: 2445.amount, whoIsPaying: [true,true,true]), // 815 per
      .init(itemName: "J3", itemCost: 776.amount, whoIsPaying: [false,true,true]), // 388 per
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsSubtotal, 2065.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsSubtotal, 1203.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsSubtotal, 2453.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown.first?.costToPayer, 0.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown[1].costToPayer, 815.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown[2].costToPayer, 0.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown[2].costToPayer, 388.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown[2].costToPayer, 388.amount)
  }
  
  func testBillSplitSingleDivisibleItemWithDivisibleAdjustment() {
    let people: [PersonModel] = ["GL", "AB", "CD"].map { PersonModel(name: $0) }
    let payers: [PayerModel] = people.map { PayerModel(person: $0) }
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, whoIsPaying: [true,true,true]),
    ]
    
    let adjustments: [ReceiptAdjustment] = [
      .init(adjustmentName: "tax", adjustment: .percentage(15.percentage, .runningTotal))
    ]
    
    let bill = BillModel(payers: payers, items: items, adjustments: adjustments)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPayerGrandTotals[payers[0]], 575.amount)
    XCTAssertEqual(result.perPayerGrandTotals[payers[1]], 575.amount)
    XCTAssertEqual(result.perPayerGrandTotals[payers[2]], 575.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[0]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[1]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payers[2]]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payers[0]]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payers[1]]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payers[2]]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
  }
}
