//
//  PersonCollectionViewCell.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
  override var isSelected: Bool {
    didSet {
      // TODO ????
    }
  }
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 25
    view.clipsToBounds = false
    view.backgroundColor = .secondarySystemFill
    
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: 50),
      view.heightAnchor.constraint(equalToConstant: 50),
    ])
    
    return view
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .label
    
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
  }
  
  private func setupCell() {
    containerView.addSubview(nameLabel)
    contentView.addSubview(containerView)
    
    containerView.pin(to: contentView)
    NSLayoutConstraint.activate([
      nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
    ])
  }
  
  func configure(with person: PersonModel) {
    nameLabel.text = person.name
  }
  
  func toggleSelected() {
    self.isSelected = !self.isSelected
  }
  
  func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }
}

extension PersonCollectionViewCell: Identifiable { }
