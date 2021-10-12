//
//  ReceiptModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Describes a receipt including taxes, tips, and adjustments
struct ReceiptModel {
  var items: [ReceiptItemModel]
  
  var adjustments: [AdjustmentModel]
  
  
  /// The calculated total on the receipt
  var formattedTotal: String {
    let itemTotal = items.reduce(Amount.zero) { (result, model) -> Amount in
      result + model.itemCost
    }
    
    let grandTotal = adjustments.reduce(itemTotal) { (result, model) -> Amount in
      result + model.adjustment
    }
    
    return grandTotal.formatted
  }
}
