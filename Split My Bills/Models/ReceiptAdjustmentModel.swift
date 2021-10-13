//
//  AdjustmentModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

struct ReceiptAdjustmentModel {
  var name: String
  var adjustment: Adjustment
}

extension ReceiptAdjustmentModel: Hashable { }
