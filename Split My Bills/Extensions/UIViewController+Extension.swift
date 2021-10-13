//
//  UIViewController+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

// Source: https://www.swiftbysundell.com/basics/child-view-controllers/
// TODO: REMOVE IF UNUSED
extension UIViewController {
  func add(child: UIViewController) {
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
  
  func remove() {
    // Just to be safe, we check that this view controller
    // is actually added to a parent before removing it.
    guard parent != nil else {
      return
    }
    
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
}
