//
//  AmountTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class AmountTests: XCTestCase {
  func testFormatWholeAmount() {
    let fmtd = 4600.amount.formatted
    XCTAssertEqual(fmtd, "$46.00")
  }
  
  func testFormatAmountEndingIn10Cents() {
    let fmtd = 7710.amount.formatted
    XCTAssertEqual(fmtd, "$77.10")
  }
  
  func testFormatAmountWithCents() {
    let fmtd = 1234.amount.formatted
    XCTAssertEqual(fmtd, "$12.34")
  }
  
  // MARK: - Amount portioning
  func testPortionZeroAmountIntoOnePart() {
    // TODO: WRITE
  }
  
  func testPortionDivisibleAmount() {
    // TODO: WRITE
  }
  
  func testPortionDivisibleAmountWithOneRemainder() {
    let amount = 2500.amount
    let result = amount.portion(into: 5)
    
    XCTAssertEqual(result.count, 5)
    XCTAssertEqual(result[0], 500.amount)
    XCTAssertEqual(result[1], 500.amount)
    XCTAssertEqual(result[2], 500.amount)
    XCTAssertEqual(result[3], 500.amount)
    XCTAssertEqual(result[4], 500.amount)
  }
  
  func testPortionIndivisibleAmountWithMultipleRemainder() {
    let amount = 4998.amount
    let result = amount.portion(into: 11)
    
    let baseOwed = 454.amount
    
    // remainder = 4, step size = 2.75
    XCTAssertEqual(result.count, 11)
    XCTAssertEqual(result[0], baseOwed + 1.amount)
    XCTAssertEqual(result[1], baseOwed)
    XCTAssertEqual(result[2], baseOwed)
    XCTAssertEqual(result[3], baseOwed + 1.amount)
    XCTAssertEqual(result[4], baseOwed)
    XCTAssertEqual(result[5], baseOwed + 1.amount)
    XCTAssertEqual(result[6], baseOwed)
    XCTAssertEqual(result[7], baseOwed)
    XCTAssertEqual(result[8], baseOwed + 1.amount)
    XCTAssertEqual(result[9], baseOwed)
    XCTAssertEqual(result[10], baseOwed)
    
    XCTAssertEqual(result.sum, amount)
  }
  
  // MARK: - Operator tests
  
  func testAddingAmounts() {
    let sum = 6600.amount + 1284.amount
    XCTAssertEqual(sum.rawValue, 7884)
  }
  
  func testSubtractingAmounts() {
    let diff = 4226.amount - 1284.amount
    XCTAssertEqual(diff.rawValue, 2942)
  }
  
  func testAmountWithAmountAdjustment() {
    let adjAmount = 2000.amount + Adjustment.amount(5000.amount)
    XCTAssertEqual(adjAmount.rawValue, 7000)
  }
  
  func testAmountWithPercentageAdjustment() {
    let adjAmount = 2000.amount + Adjustment.percentage(25.percentage)
    XCTAssertEqual(adjAmount.rawValue, 2500)
  }
  
  func testAmountTimesPercentageAdjustment() {
    let adjAmount = 1499.amount * 15.percentage
    XCTAssertEqual(adjAmount.rawValue, 1724)
    
  }
}
