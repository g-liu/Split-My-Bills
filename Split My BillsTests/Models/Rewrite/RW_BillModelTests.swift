//
//  RW_BillModelTests.swift
//  Split My BillsTests
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation
import XCTest
@testable import Split_My_Bills

final class RW_BillModelTests: XCTestCase {
  
  func testBillSplitItemsOnly() {
    let people: [PersonModel] = ["GL", "AB", "CD"].map { PersonModel(name: $0) }
    let payers: [RW_Payer] = people.map { RW_Payer(person: $0) }
    
    let items: [RW_ReceiptItemModel] = [
      .init(itemName: "J1", itemCost: 1499.amount, whoIsPaying: [true,true,false]),
      .init(itemName: "J2", itemCost: 750.amount, whoIsPaying: [false,true,true]),
    ]
    
    let bill = RW_BillModel(payers: payers, items: items)
    let result = bill.splitBill
    
    XCTAssertEqual(result.perPayerItemsBreakdown.count, 3)
    XCTAssertEqual(result.perPayerAdjustmentsBreakdown.count, 3)
  }
}
