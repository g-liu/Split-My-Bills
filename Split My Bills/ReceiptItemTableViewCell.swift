//
//  ReceiptItemTableViewCell.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

final class ReceiptItemTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    
  }
  
  func configure(with model: ReceiptItemModel) {
    textLabel?.text = model.itemName
    detailTextLabel?.text = model.formattedItemCost
  }

}

extension ReceiptItemTableViewCell: Identifiable { }