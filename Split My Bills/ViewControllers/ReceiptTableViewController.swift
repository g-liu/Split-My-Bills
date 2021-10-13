//
//  ReceiptTableViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class ReceiptTableViewController: UITableViewController {
  var billState: BillStateModel
  
  init(billState: BillStateModel) {
    self.billState = billState
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.billState = .init()
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    registerCells()
  }

  private func registerCells() {
    tableView.register(ReceiptItemTableViewCell.self, forCellReuseIdentifier: ReceiptItemTableViewCell.identifier)
    tableView.register(ReceiptAdjustmentTableViewCell.self, forCellReuseIdentifier: ReceiptAdjustmentTableViewCell.identifier)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ReceiptTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    3
    // Section 0: Items
    // Section 1: Adjustments
    // Section 2: Total
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case 0:
        return 1 + billState.receipt.items.count
      case 1:
        return 1 + billState.receipt.adjustments.count
      case 2:
        return 1
      default:
        return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
      case 0:
        return cellForItemsSection(indexPath)
      case 1:
        return cellForAdjustmentsSection(indexPath)
      default:
        // TODO actually do the shit
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        return cell
    }
  }
  
  private func cellForItemsSection(_ indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      // this is the last row and should be "ADD CELL"
      // TODO: REPLACE WITH A BETTER "ADD" cell
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
      
      cell.textLabel?.text = "Add item"
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptItemTableViewCell.identifier) as? ReceiptItemTableViewCell else { return UITableViewCell() }
    
    let fakeAssModel = ReceiptItemModel(itemName: "BABA BOOEY", itemCost: Amount(rawValue: 1499))
    cell.configure(with: fakeAssModel)
    return cell
  }
  
  private func cellForAdjustmentsSection(_ indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      // this is the last row and should be "ADD CELL"
      // TODO: REPLACE WITH A BETTER "ADD" cell
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
      
      cell.textLabel?.text = "Add item"
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptAdjustmentTableViewCell.identifier) as? ReceiptAdjustmentTableViewCell else { return UITableViewCell() }
    
    let fakeAssAdjustment = ReceiptAdjustmentModel(name: "tip", adjustment: .percentage(15.0.percentage, .runningTotal))
    cell.configure(with: fakeAssAdjustment)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
      case 0:
        didSelectCellInItemsSection(indexPath)
      case 1:
        didSelectCellInAdjustmentsSection(indexPath)
      case 2:
        // no-op
        break
      default:
        // no-op
        break
    }
  }
  
  private func didSelectCellInItemsSection(_ indexPath: IndexPath) {
    if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      // this means they pressed "add item"
      let addItemVC = AddReceiptItemViewController(billState: billState)
      navigationController?.present(addItemVC, animated: true, completion: nil)
    }
  }
  
  private func didSelectCellInAdjustmentsSection(_ indexPath: IndexPath) {
    if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
      // this means they pressed "add item"
      
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
      case 0:
        return "Items"
      case 1:
        return "Adjustments"
      case 2:
        return "Grand Total"
      default:
        return nil
    }
  }
}
