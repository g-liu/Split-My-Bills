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
  private let payer1 = PayerModel(person: PersonModel(name: "GL"))
  private let payer2 = PayerModel(person: PersonModel(name: "CN"))
  private let payer3 = PayerModel(person: PersonModel(name: "TA"))
  private let payer4 = PayerModel(person: PersonModel(name: "ZG"))
  private let payer5 = PayerModel(person: PersonModel(name: "JW"))
  
  func testBillDivisionOfEmptyBill() {
    let payers = [payer1, payer2]

    let billState = BillModel(payers: payers)
    let result = billState.splitBill

    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.subtotalToPayer, .zero)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.subtotalToPayer, .zero)
  }
  
  func testBillSplitSingleDivisibleItem() {
    let payers = [payer1, payer2, payer3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.subtotalToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.subtotalToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.subtotalToPayer, 500.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown.first?.costToPayer, 500.amount)
  }
  
  func testBillSplitMultipleDivisibleItems() {
    let payers = [payer1, payer2, payer3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
      .init(itemName: "J2", itemCost: 2442.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.subtotalToPayer, 1314.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.subtotalToPayer, 1314.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.subtotalToPayer, 1314.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown[1].costToPayer, 814.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown[1].costToPayer, 814.amount)
  }
  
  func testBillUnevenlySplitMultipleDivisbleItems() {
    let payers = [payer1, payer2, payer3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 2500.amount, isBillableToPayer: [true,false,true]), // 1250 per
      .init(itemName: "J2", itemCost: 2445.amount, isBillableToPayer: [true,true,true]), // 815 per
      .init(itemName: "J3", itemCost: 776.amount, isBillableToPayer: [false,true,true]), // 388 per
    ]
    
    let bill = BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.subtotalToPayer, 2065.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.subtotalToPayer, 1203.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.subtotalToPayer, 2453.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown.first?.costToPayer, 0.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown.first?.costToPayer, 1250.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown[1].costToPayer, 815.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown[1].costToPayer, 815.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown[2].costToPayer, 0.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown[2].costToPayer, 388.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown[2].costToPayer, 388.amount)
  }
  
  func testBillSplitSingleDivisibleItemWithDivisibleAdjustment() {
    let payers = [payer1, payer2, payer3]
    
    let items: [ReceiptItem] = [
      .init(itemName: "J1", itemCost: 1500.amount, isBillableToPayer: [true,true,true]),
    ]
    
    let adjustments: [ReceiptAdjustment] = [
      .init(adjustmentName: "tax", adjustment: .percentage(15.percentage, .runningTotal))
    ]
    
    let bill = BillModel(payers: payers, items: items, adjustments: adjustments)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown.count, 3)
    
    XCTAssertEqual(result.perPayerGrandTotals[payer1], 575.amount)
    XCTAssertEqual(result.perPayerGrandTotals[payer2], 575.amount)
    XCTAssertEqual(result.perPayerGrandTotals[payer3], 575.amount)
    
    XCTAssertEqual(result.perPayerItemsBreakdown[payer1]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer2]?.itemsBreakdown.first?.costToPayer, 500.amount)
    XCTAssertEqual(result.perPayerItemsBreakdown[payer3]?.itemsBreakdown.first?.costToPayer, 500.amount)
    
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payer1]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payer2]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown[payer3]?.adjustmentsBreakdown.first?.costEquivalentToPayer, 75.amount)
  }
}
