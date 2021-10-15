//
//  BillSetupViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class BillSetupViewController: UIViewController {
  private var billModel: BillModel
  
  lazy var addPeopleButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add people", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(nil, action: #selector(didTapAddPeopleButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var addReceiptButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add receipt", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(nil, action: #selector(didTapAddReceiptButton), for: .touchUpInside)
    
    return button
  }()
  
  lazy var settleUpButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Settle up", for: .normal)
    button.setTitleColor(.label, for: .normal)
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
  
  init(billModel: BillModel = .init()) {
    self.billModel = billModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.billModel = .init()
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    stackView.addArrangedSubview(addPeopleButton)
    stackView.addArrangedSubview(addReceiptButton)
    stackView.addArrangedSubview(settleUpButton)
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  @objc private func didTapAddPeopleButton() {
    let peopleVC = PeopleViewController(billModel: billModel)
    peopleVC.peopleDelegate = self
    navigationController?.pushViewController(peopleVC, animated: true)
  }
  
  @objc private func didTapAddReceiptButton() {
    let receiptVC = ReceiptTableViewController(billModel: billModel)
    navigationController?.pushViewController(receiptVC, animated: true)
  }
  
  @objc private func didTapSettleUpButton() {
    
  }
}

extension BillSetupViewController: PeopleDelegate {
  func didSetPeople(_ people: String) {
    billModel.persons = people.split(separator: "\n").map {
      PersonModel(name: String($0))
    }
    
    // there has to be a better way LOL
    addPeopleButton.setTitle("Add people (\(billModel.persons.count))", for: .normal)
  }
}
