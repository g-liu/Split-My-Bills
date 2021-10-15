//
//  PercentageTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class PercentageTests: XCTestCase {
  func testFormatZeroPercent() {
    let zero = Percentage.zero
    XCTAssertEqual(zero.formatted, "0%")
  }
  
  func testFormatIntegerPercent() {
    let pct = 4.percent
    XCTAssertEqual(pct.formatted, "4%")
  }
  
  func testFormatDecimalPecent() {
    let pct = 8.815.percent
    XCTAssertEqual(pct.formatted, "8.8%")
  }
  
  func testFormatDecimalPercentToPlaces() {
    let pct = 5.529.percent
    XCTAssertEqual(pct.formatted(to: 2), "5.53%")
  }
  
  func testFormatNegativePercentages() {
    let pct = (-15.77777).percent
    XCTAssertEqual(pct.formatted, "-15.8%")
  }
  
  func testPercentagesEqual() {
    let pct1 = 1.percent
    let pct2 = 1.0.percent
    
    XCTAssertEqual(pct1, pct2)
  }
  
  func testPercentagesNotEqual() {
    let pct1 = 49.1112.percent
    let pct2 = 49.1111.percent
    
    XCTAssertNotEqual(pct1, pct2)
  }

}
