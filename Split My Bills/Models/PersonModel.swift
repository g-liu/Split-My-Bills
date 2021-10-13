//
//  PersonModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

/// Describes a person
struct PersonModel {
  var name: String
}

extension PersonModel: Equatable, Hashable { }

extension PersonModel: Comparable {
  static func < (lhs: PersonModel, rhs: PersonModel) -> Bool {
    lhs.name < rhs.name
  }
}
