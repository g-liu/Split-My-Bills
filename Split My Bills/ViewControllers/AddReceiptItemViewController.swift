//
//  AddReceiptItemViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class AddReceiptItemViewController: UIViewController {
  private lazy var nameField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .sentences
    textField.placeholder = "California roll"
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    return textField
  }()
  
  private lazy var priceField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .sentences
    textField.keyboardType = .numbersAndPunctuation
    textField.placeholder = "7.65"
    textField.setContentHuggingPriority(.required, for: .horizontal)
    textField.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return textField
  }()
  
  private lazy var dollarSignLabel: UILabel = {
    // TODO: Localize!
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "$"
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    stackView.addArrangedSubview(nameField)
    stackView.addArrangedSubview(dollarSignLabel)
    stackView.addArrangedSubview(priceField)
    
    nameField.becomeFirstResponder()
    
    view.backgroundColor = .white
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
}
