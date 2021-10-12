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
