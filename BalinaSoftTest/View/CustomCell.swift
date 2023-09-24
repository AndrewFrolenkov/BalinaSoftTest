//
//  CustomCell.swift
//  BalinaSoftTest
//
//  Created by Андрей Фроленков on 24.09.23.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
  static var reuseId: String { get }
}

// MARK: - CustomCell
class CustomCell: UITableViewCell, SelfConfiguringCell {
  static var reuseId: String = "Cell"
  
  // MARK: - Private Property
  lazy var nameLabel = {
    let nameLabel = UILabel()
    return nameLabel
  }()
  

  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    setupConstraints()
  }
  
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  private func configure() {
    addSubview(nameLabel)
  }
  
}

// MARK: - Setup constraints
private extension CustomCell {
  func setupConstraints() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}
