//
//  PeopleSelectorViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class PeopleSelectorViewController: UIViewController {
  private let billState: BillStateModel
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.itemSize = CGSize(width: 50, height: 50) // TODO: DYNAMIC LAYOUT
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.delegate = self
    cv.dataSource = self
    
    return cv
  }()
  
  lazy var selectAllButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Select all", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(nil, action: #selector(selectAllPersons), for: .touchUpInside)
    
    return button
  }()
  
  lazy var clearSelectionButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Clear selection", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(nil, action: #selector(clearPersonsSelection), for: .touchUpInside)
    
    return button
  }()
  
  lazy var presetSelectionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    
    return stackView
  }()
  
  lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fill
    
    return stackView
  }()
  
  init(billState: BillStateModel) {
    self.billState = billState
    super.init(nibName: nil, bundle: nil)
    
    setupVC()
  }
  
  required init?(coder: NSCoder) {
    self.billState = .init()
    super.init(coder: coder)
    
    setupVC()
  }
  
  private func setupVC() {
    presetSelectionStackView.addArrangedSubview(selectAllButton)
    presetSelectionStackView.addArrangedSubview(clearSelectionButton)
    
    mainStackView.addSubview(presetSelectionStackView)
    mainStackView.addSubview(collectionView)
    
    presetSelectionStackView.pinSides(to: mainStackView)
    collectionView.pinSides(to: mainStackView)
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view)
    
    registerCells()
  }
  
  private func registerCells() {
    collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: PersonCollectionViewCell.identifier)
  }
  
  @objc private func selectAllPersons() {
    billState.people.enumerated().forEach { index, person in
      let indexPath = IndexPath(row: index, section: 0)
      guard let cell = collectionView.cellForItem(at: indexPath) as? PersonCollectionViewCell else { return }
      
      cell.setSelected(true)
    }
  }
  
  @objc private func clearPersonsSelection() {
    billState.people.enumerated().forEach { index, person in
      let indexPath = IndexPath(row: index, section: 0)
      guard let cell = collectionView.cellForItem(at: indexPath) as? PersonCollectionViewCell else { return }
      
      cell.setSelected(false)
    }
  }
  
}

extension PeopleSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    billState.people.count
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.identifier, for: indexPath) as? PersonCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    cell.configure(with: billState.people[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? PersonCollectionViewCell else { return }
    cell.toggleSelected()
  }
  
  
}
