//
//  ReceiptItemTableViewCell.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class ReceiptItemTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    
  }
  
  func configure(with model: RW_ReceiptItemModel) {
    textLabel?.text = model.itemName
    detailTextLabel?.text = model.itemCost.formatted
  }

}

extension ReceiptItemTableViewCell: Identifiable { }
