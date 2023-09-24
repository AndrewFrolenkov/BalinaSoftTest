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
  private lazy var tableView = UITableView()
  private lazy var activityIndicatorCenter = UIActivityIndicatorView()
  
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
    configureTableView()
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
    view.addSubview(activityIndicatorCenter)
    view.addSubview(tableView)
  }
  
  func configureTableView() {
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.backgroundColor = .clear
    tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseId)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  //  show/hide ActivityIndicator
  func showActivityIndicator() {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.startAnimating()
    tableView.tableFooterView = activityIndicator
  }
  
  func hideActivityIndicator() {
    tableView.tableFooterView = nil
  }
}

// MARK: - Layout
private extension ListViewController {
  func setupLayout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorCenter.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      activityIndicatorCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicatorCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseId, for: indexPath) as! CustomCell
    cell.nameLabel.text = "\(indexPath.row)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
}
