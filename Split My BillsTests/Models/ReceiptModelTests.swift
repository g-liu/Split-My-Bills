//
//  ReceiptModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/12/21.
//

import XCTest
@testable import Split_My_Bills

final class ReceiptModelTests: XCTestCase {
  func testFormattedTotalOnEmptyReceipt() {
    let receipt = ReceiptModel()
    XCTAssertEqual(receipt.formattedTotal, "$0.00")
  }
  
  func testFormattedTotalOnItemsOnlyReceipt() {
    let items = [1700, 1399, 900, 842].map {
      ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount)
    }
    let receipt = ReceiptModel(items: items)
    
    XCTAssertEqual(receipt.formattedTotal, "$48.41")
  }
  
  func testFormattedTotalOnPercentageAdjustmentsOnlyReceipt() {
    let adjustments = [27, 24, 8.4].map {
      return AdjustmentModel(name: "whatevs", adjustment: .percentage($0.percentage))
    }
    let receipt = ReceiptModel(adjustments: adjustments)
    
    XCTAssertEqual(receipt.formattedTotal, "$0.00")
  }
  
  func testFormattedTotalOnAmountAdjustmentsOnlyReceipt() {
    let adjustments = [499, 1200, -560].map {
      return AdjustmentModel(name: "whatevs", adjustment: .amount($0.amount))
    }
    let receipt = ReceiptModel(adjustments: adjustments)
    
    XCTAssertEqual(receipt.formattedTotal, "$11.39")
  }
  
  func testFormattedTotalOnAllAdjustmentsOnlyReceipt() {
    let adjustments = [
      Adjustment.amount(200.amount),
      Adjustment.percentage(15.percentage),
      Adjustment.amount((-50).amount),
    ].map {
      return AdjustmentModel(name: "whatevs", adjustment: $0)
    }
    let receipt = ReceiptModel(adjustments: adjustments)
    XCTAssertEqual(receipt.formattedTotal, "$1.80")
  }
  
  func testFormattedTotalOnItemsAndPercentageAdjustmentsReceipt() {
    let items = [520, 499, 887].map {
      ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount)
    }
    
    let adjustments = [8, 15].map {
      AdjustmentModel(name: "whatevs", adjustment: Adjustment.percentage($0.percentage))
    }
    
    let receipt = ReceiptModel(items: items, adjustments: adjustments)
    
    XCTAssertEqual(receipt.formattedTotal, "$23.67")
  }
  
  func testFormattedTotalOnItemsAndAmountAdjustmentsReceipt() {
    let items = [520, 499, 887].map {
      ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount)
    }
    
    let adjustments = [-199].map {
      AdjustmentModel(name: "discount", adjustment: .amount($0.amount))
    }
    
    let receipt = ReceiptModel(items: items, adjustments: adjustments)
    
    XCTAssertEqual(receipt.formattedTotal, "$17.07")
  }
  
  func testFormattedTotalOnItemsAndAllAdjustmentsReceipt() {
    let items = [4250, 899, 1700, 1232].map {
      ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount)
    }
    
    let adjustments = [
      Adjustment.amount(350.amount),
      Adjustment.percentage(18.5.percentage),
      Adjustment.amount((-1200).amount),
    ].map {
      AdjustmentModel(name: "discount", adjustment: $0)
    }
    
    let receipt = ReceiptModel(items: items, adjustments: adjustments)
    
    XCTAssertEqual(receipt.formattedTotal, "$87.91")
  }
}
