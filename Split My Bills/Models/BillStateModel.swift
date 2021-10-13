//
//  BillStateModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

struct BillStateModel {
  var payers: [PersonModel]
  
  var receipt: ReceiptModel
  
  init(payers: [PersonModel] = [], receipt: ReceiptModel = .init()) {
    self.payers = payers
    self.receipt = receipt
  }
  
  var payersAsList: String {
    payers.reduce("") { (result, model) -> String in
      result + "\n" + model.name
    }
  }
}
