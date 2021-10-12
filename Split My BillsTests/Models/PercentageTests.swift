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

}
