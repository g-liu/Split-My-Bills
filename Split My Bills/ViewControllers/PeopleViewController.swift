//
//  PeopleViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class PeopleViewController: UIViewController {
  private lazy var peopleEntryTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    return textField
  }()
  
  private lazy var confirmButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Confirm", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .leading
    
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    stackView.addArrangedSubview(peopleEntryTextField)
    stackView.addArrangedSubview(confirmButton)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    stackView.pin(to: view)
  }
}
