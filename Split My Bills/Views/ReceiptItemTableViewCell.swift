//
//  ReceiptItemTableViewCell.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class ReceiptItemTableViewCell: UITableViewCell {
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
    textField.keyboardType = .decimalPad
    textField.placeholder = "7.65"
    textField.setContentHuggingPriority(.required, for: .horizontal)
    textField.setContentCompressionResistancePriority(.required, for: .horizontal)
    textField.delegate = self
    
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
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
  }
  
  private func setupCell() {
    stackView.addArrangedSubview(nameField)
    stackView.addArrangedSubview(dollarSignLabel)
    stackView.addArrangedSubview(priceField)
    
    contentView.backgroundColor = .white
    
    contentView.addSubview(stackView)
    stackView.pin(to: contentView.safeAreaLayoutGuide)
  }
  
  func configure(with model: ReceiptItemModel) {
    nameField.text = model.itemName
    priceField.text = model.formattedItemCost
  }

}

extension ReceiptItemTableViewCell: UITextFieldDelegate {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard !string.isEmpty else {
      return true
    }
    
    // Input Validation
    // Prevent invalid character input, if keyboard is numberpad
    if textField.keyboardType == .decimalPad {
      
      // Check for invalid input characters
      if !CharacterSet(charactersIn: "0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) {
        return false
      }
    }
    
    // Allow text change
    return true
  }
}

extension ReceiptItemTableViewCell: Identifiable { }

