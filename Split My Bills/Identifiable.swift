//
//  Identifiable.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

public protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  public static var identifier: String {
    String(describing: self)
  }
}
