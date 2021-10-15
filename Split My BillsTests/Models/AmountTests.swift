//
//  AmountTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

// TODO: TEST WITH NEGATIVE OPERATIONS
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
  func testPortionZeroInto5() {
    let (quotient, remainder) = Amount.zero.portion(into: 5)
    XCTAssertEqual(quotient, .zero)
    XCTAssertEqual(remainder, .zero)
  }
  
  func testPortionByNegativeCount() {
    let (quotient, remainder) = 5000.amount.portion(into: -2)
    XCTAssertEqual(quotient, .zero)
    XCTAssertEqual(remainder, .zero)
  }
  
  func testPortionDivisibleAmount() {
    let (quotient, remainder) = 5219.amount.portion(into: 40)
    XCTAssertEqual(quotient, 130.amount)
    XCTAssertEqual(remainder, 19.amount)
  }
  
  func testPortionNonDivisibleAmount() {
    let (quotient, remainder) = 5000.amount.portion(into: -2)
    XCTAssertEqual(quotient, .zero)
    XCTAssertEqual(remainder, .zero)
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
  
  func testAmountTimesPercentageAdjustment() {
    let adjAmount = 1499.amount * 15.percentage
    XCTAssertEqual(adjAmount.rawValue, 225)
  }
}
