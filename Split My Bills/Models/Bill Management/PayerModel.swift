//
//  PayerModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/14/21.
//

import Foundation

struct PayerModel: Hashable {
  var person: PersonModel
  var remaindersPaid: Amount = .zero
}
