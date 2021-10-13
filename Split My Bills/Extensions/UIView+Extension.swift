//
//  UIView+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

extension UIView {
  func pinSides(to superview: UIView) {
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
    ])
  }
  
  func pin(to superview: UIView) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
    ])
  }
  
  func pin(to layoutGuide: UILayoutGuide) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
    ])
  }
}
