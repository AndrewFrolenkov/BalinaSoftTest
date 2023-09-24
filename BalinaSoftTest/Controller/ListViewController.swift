//
//  ListViewController.swift
//  BalinaSoftTest
//
//  Created by Андрей Фроленков on 24.09.23.
//

import UIKit

// MARK: - ListViewController
class ListViewController: UIViewController {
  
  // MARK: - Private Property
  
  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  
}

// MARK: - Setting Views
private extension ListViewController {
  func setupView() {
    configureSuperView()
    addSubview()
    
    setupLayout()
  }
  
  func configureSuperView() {
    view.backgroundColor = UIColor.mainWhite()
  }
}

// MARK: - Setting
private extension ListViewController {
  func addSubview() {
    
  }
}

// MARK: - Layout
private extension ListViewController {
  func setupLayout() {
    
  }
}

