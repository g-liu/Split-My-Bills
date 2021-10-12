//
//  ReceiptTableViewController.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class ReceiptTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    registerCells()
  }

  private func registerCells() {
    tableView.register(ReceiptItemTableViewCell.self, forCellReuseIdentifier: ReceiptItemTableViewCell.identifier)
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ReceiptTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptItemTableViewCell.identifier) as? ReceiptItemTableViewCell else { return UITableViewCell() }
    
    let fakeAssModel = ReceiptItemModel(itemName: "BABA BOOEY", itemCost: Amount(rawValue: 14.99))
    cell.configure(with: fakeAssModel)
    return cell
  }
}
