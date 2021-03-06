//
//  AddReceiptItemViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class AddReceiptItemViewController: UIViewController {
  private let billModel: BillModel
  
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
    textField.minimumFontSize = 28.0
    
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
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    
    return stackView
  }()
  
  private lazy var peopleSelectorVC: UIViewController = {
    let vc = PeopleSelectorViewController(billModel: billModel)
    return vc
  }()
  
  init(billModel: BillModel) {
    self.billModel = billModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.billModel = .init()
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(peopleSelectorVC)
    
    stackView.addArrangedSubview(nameField)
//    stackView.addArrangedSubview(dollarSignLabel) // TODO: layout needs to go with price field.
    stackView.addArrangedSubview(priceField)
    stackView.addArrangedSubview(peopleSelectorVC.view)
    
    peopleSelectorVC.didMove(toParent: self)
    
    nameField.becomeFirstResponder()
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  deinit {
    peopleSelectorVC.view.removeFromSuperview()
    peopleSelectorVC.removeFromParent()
  }
}
