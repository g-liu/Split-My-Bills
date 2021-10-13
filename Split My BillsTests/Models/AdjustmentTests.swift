//
//  AdjustmentTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class AdjustmentTests: XCTestCase {

  func testFormattedPercentage() {
    let adj = Adjustment.percentage(14.8.percentage, .runningTotal).formatted
    XCTAssertEqual(adj, "14.8%")
  }
  
  func testFormattedAmount() {
    let adj = Adjustment.amount(1250.amount).formatted
    XCTAssertEqual(adj, "$12.50")
  }

}
