//
//  Double+Extension_Tests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class Double_Extension_Tests: XCTestCase {
  func testDoubleConversionToPercentage() {
    let pctFromDouble = 2.345.percent
    let pctFromPct = Percentage(percent: 2.345)
    
    XCTAssertEqual(pctFromDouble, pctFromPct)
  }
}
