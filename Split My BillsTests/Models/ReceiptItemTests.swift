//
//  ReceiptItemTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class ReceiptItemTests: XCTestCase {
  func testDefaultInitialization() {
    let im = ReceiptItemModel(itemName: "heh")
    XCTAssertEqual(im.itemCost, .zero)
    XCTAssert(im.payers.isEmpty)
    XCTAssertEqual(im.itemName, "heh")
  }
  
  func testFormattedCost() {
    let im = ReceiptItemModel(itemName: "food", itemCost: 3811.amount)
    XCTAssertEqual(im.formattedItemCost, "$38.11")
  }
}
