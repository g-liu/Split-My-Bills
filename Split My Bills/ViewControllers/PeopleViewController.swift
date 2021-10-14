//
//  PeopleViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class PeopleViewController: UIViewController {
  private lazy var peopleEntryTextView: UITextView = {
    let textField = UITextView()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isEditable = true
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .words
    
    return textField
  }()
  
  private lazy var confirmButton: UIButton = { // TODO make ui bar button?
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Confirm", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(nil, action: #selector(didTapConfirmButton), for: .touchUpInside)
    
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
  
  weak var peopleDelegate: PeopleDelegate?
  
  init(billModel: BillModel) {
    super.init(nibName: nil, bundle: nil)
    let text = billModel.payersNewlineDelineatedList
    peopleEntryTextView.text = text
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stackView.addArrangedSubview(peopleEntryTextView)
    stackView.addArrangedSubview(confirmButton)
    
    peopleEntryTextView.pinSides(to: stackView)
    confirmButton.pinSides(to: stackView)
    
    peopleEntryTextView.becomeFirstResponder()
    
    view.backgroundColor = .systemBackground
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
  
  @objc func didTapConfirmButton() {
    peopleDelegate?.didSetPeople(peopleEntryTextView.text) // TODO: Currently there is zero support for editing names.
    // Operation will CLEAR AND RESET people!
    peopleEntryTextView.resignFirstResponder()
    navigationController?.popViewController(animated: true)
  }
}
