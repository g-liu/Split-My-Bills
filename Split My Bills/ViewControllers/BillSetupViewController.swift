//
//  BillSetupViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class BillSetupViewController: UIViewController {
  private let billState: BillStateModel
  
  lazy var addPeopleButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add people", for: .normal)
    button.setTitleColor(.black, for: .normal) // TODO: DARK MODE?
    button.addTarget(nil, action: #selector(didTapAddPeopleButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var addReceiptButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add receipt", for: .normal)
    button.setTitleColor(.black, for: .normal) // TODO: DARK MODE?
    button.addTarget(nil, action: #selector(didTapAddReceiptButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var settleUpButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Settle up", for: .normal)
    button.setTitleColor(.black, for: .normal) // TODO: DARK MODE?
    button.addTarget(nil, action: #selector(didTapSettleUpButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    
    return stackView
  }()
  
  init(billState: BillStateModel = .init()) {
    self.billState = billState
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.billState = BillStateModel()
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white // TODO: Support dark-mode
    view.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(addPeopleButton)
    stackView.addArrangedSubview(addReceiptButton)
    stackView.addArrangedSubview(settleUpButton)
    
    view.addSubview(stackView)
    stackView.pin(to: view)
  }
  
  @objc private func didTapAddPeopleButton() {
    
  }
  
  @objc private func didTapAddReceiptButton() {
    
  }
  
  @objc private func didTapSettleUpButton() {
    
  }
}
