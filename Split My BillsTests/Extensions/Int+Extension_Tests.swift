//
//  Int+Extension_Tests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class Int_Extension_Tests: XCTestCase {
  func testIntConversionToPercentage() {
    let pctFromInt = 1.percentage
    let pctFromPct = Percentage(percent: 1)
    
    XCTAssertEqual(pctFromInt, pctFromPct)
  }
}
