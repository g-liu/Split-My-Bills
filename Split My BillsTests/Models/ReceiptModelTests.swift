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
  
  func testAddItemToReceipt() {
    var receipt = ReceiptModel()
    XCTAssertEqual(receipt.formattedTotal, "$0.00")
    
    let item = ReceiptItemModel(itemName: "whatevs", itemCost: 40000.amount)
    receipt.addItem(item)
    XCTAssertEqual(receipt.formattedTotal, "$400.00")
  }
  
  func testRemoveNonExistentItemFromReceipt() {
    let items = [2850, 200].map { ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount) }
    var receipt = ReceiptModel(items: items)
    XCTAssertEqual(receipt.formattedTotal, "$30.50")
    
    let ri1 = receipt.removeItem(at: -1)
    let ri2 = receipt.removeItem(at: 2)
    XCTAssertNil(ri1)
    XCTAssertNil(ri2)
  }
  
  func testRemoveItemFromReceipt() {
    let items = [2850, 200].map { ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount) }
    var receipt = ReceiptModel(items: items)
    XCTAssertEqual(receipt.formattedTotal, "$30.50")
    
    let removedItem = receipt.removeItem(at: 0)!
    XCTAssertEqual(removedItem.formattedItemCost, "$28.50")
    XCTAssertEqual(receipt.formattedTotal, "$2.00")
  }
  
  func testAddAdjustmentToReceipt() {
    let items = [2850, 200].map { ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount) }
    var receipt = ReceiptModel(items: items)
    XCTAssertEqual(receipt.formattedTotal, "$30.50")
    
    receipt.addAdjustment(AdjustmentModel(name: "tip", adjustment: Adjustment.percentage(15.percentage)))
    XCTAssertEqual(receipt.formattedTotal, "$35.08")
  }
  
  func testRemoveNonExistentAdjustmentFromReceipt() {
    let items = [2850, 200].map { ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount) }
    let adjustments = [
      AdjustmentModel(name: "fee", adjustment: Adjustment.amount(1200.amount)),
      AdjustmentModel(name: "tax", adjustment: Adjustment.percentage(6.percentage)),
    ]
    var receipt = ReceiptModel(items: items, adjustments: adjustments)
    XCTAssertEqual(receipt.formattedTotal, "$45.05")
    
    let ra1 = receipt.removeAdjustment(at: -1)
    let ra2 = receipt.removeAdjustment(at: 5)
    
    XCTAssertNil(ra1)
    XCTAssertNil(ra2)
  }
  
  func testRemoveAdjustmentFromReceipt() {
    let items = [2850, 200].map { ReceiptItemModel(itemName: "whatevs", itemCost: $0.amount) }
    let adjustments = [
      AdjustmentModel(name: "fee", adjustment: Adjustment.amount(1200.amount)),
      AdjustmentModel(name: "tax", adjustment: Adjustment.percentage(6.percentage)),
    ]
    var receipt = ReceiptModel(items: items, adjustments: adjustments)
    XCTAssertEqual(receipt.formattedTotal, "$45.05")
    
    let removedAdjustment = receipt.removeAdjustment(at: 0)!
    if case let Adjustment.amount(amount) = removedAdjustment.adjustment {
      XCTAssertEqual(amount, 1200.amount)
    } else {
      XCTFail("removeAdjustment failed")
    }
    XCTAssertEqual(receipt.formattedTotal, "$32.33")
  }
}