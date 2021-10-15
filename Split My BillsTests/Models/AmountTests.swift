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
  
  func testScaleAmountByZero() {
    let result = 142325.amount * 0
    XCTAssertEqual(result, .zero)
  }
  
  func testScaleAmountByNegativeMultiple() {
    let result = 45.amount * -2
    XCTAssertEqual(result, (-90).amount)
  }
  
  func testScaleNegativeAmountByPositiveMultiple() {
    let result = (-45).amount * 2
    XCTAssertEqual(result, (-90).amount)
  }
  
  func testScaleNegativeAmountByNegativeMultiple() {
    let result = (-45).amount * -2
    XCTAssertEqual(result, 90.amount)
  }
  
  func testScaleAmountByPositiveMultiple() {
    let result = 1243.amount * 46
    XCTAssertEqual(result, 57178.amount)
  }
  
  func testMultiplyAmountByZeroPercent() {
    let result = 444444.amount * 0.percent
    XCTAssertEqual(result, .zero)
  }
  
  func testMultiplyAmountBy100Percent() {
    let result = 1743.amount * 100.percent
    XCTAssertEqual(result, 1743.amount)
  }
  
  func testMultiplyAmountByPercentResultingInRoundingDown() {
    let result = 14.amount * 16.percent
    XCTAssertEqual(result, 2.amount)
  }
  
  func testMultiplyAmountByPercentResultingInRoundingUp() {
    let result = 14.amount * 20.percent
    XCTAssertEqual(result, 3.amount)
  }
  
  func testZeroRemainderOfAmountByPercent() {
    let result = 168.amount % 100.percent
    XCTAssertEqual(result, 0.0)
  }
  
  func testNonzeroRemainderOfAmountByPercent() {
    let result = 168.amount % 38.percent
    XCTAssertEqual(result, 0.84, accuracy: 0.00000000001)
  }
  
  func testNonzeroRemainderOfAmountByNegativePercent() {
    let result = 168.amount % (-38).percent
    XCTAssertEqual(result, -0.84, accuracy: 0.00000000001)
  }
  
  func testNonzeroRemainderOfNegativeAmountByPercent() {
    let result = (-168).amount % 38.percent
    XCTAssertEqual(result, -0.84, accuracy: 0.00000000001)
  }
  
  func testNonzeroRemainderOfNegativeAmountByNegativePercent() {
    let result = (-168).amount % (-38).percent
    XCTAssertEqual(result, 0.84, accuracy: 0.00000000001)
  }
  
  func testDivideAmountByZero() {
    let result = (414).amount / 0
    
  }
  
  func testAmountTimesPercentageAdjustment() {
    let adjAmount = 1499.amount * 15.percent
    XCTAssertEqual(adjAmount.rawValue, 225)
  }
}
