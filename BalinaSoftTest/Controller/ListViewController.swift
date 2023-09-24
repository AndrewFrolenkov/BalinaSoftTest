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
  var currentPage = 1
  var totalPage = 0
  var isLoadingData = false // флаг для отслеживания первоначальной загрузки
  var isLoadingDataPage = false // Флаг для отслеживания загрузки данных
  
  // MARK: Model
  var page: Page?
  
  
  
  // MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    fetchPhotosFromServer()
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
  
  func createAlertController() {
    let alert = UIAlertController(title: "Ошибка", message: "Все элементы загружены", preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(alertAction)
    self.present(alert, animated: true)
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

// MARK: - Networking
extension ListViewController {
  func fetchPhotosFromServer() {
    tableView.tableFooterView = nil
    activityIndicatorCenter.startAnimating()
    NetworkService.shared.fetchPhotoTypes(page: 0) { [weak self] result in
      switch result {
      case .success(let page):
        // Обновите массив photos с данными о фотографиях
        self?.page = page
        
        // Обновите UITableView на основе полученных данных
        DispatchQueue.main.async {
          self?.currentPage = page.totalPages - page.totalPages + 1
          self?.totalPage = page.totalPages
          self?.isLoadingData = true
          self?.activityIndicatorCenter.stopAnimating()
          self?.tableView.reloadData()
          
        }
      case .failure(let error):
        // Обработка ошибки, например, показав сообщение об ошибке пользователю
        print("Error fetching photos: \(error)")
      }
    }
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return page?.content.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let page = page?.content[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseId, for: indexPath) as! CustomCell
    cell.nameLabel.text = page?.name
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Проверяем, достиг ли пользователь конца таблицы
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let tableHeight = scrollView.frame.height
    
    if isLoadingData {
      if !isLoadingDataPage && offsetY + tableHeight > contentHeight {
        isLoadingDataPage = true
        showActivityIndicator()
        if currentPage == totalPage {
          hideActivityIndicator()
          createAlertController()
        } else {
          NetworkService.shared.fetchPhotoTypes(page: currentPage) { [weak self] result in
            switch result {
            case .success(let page):
              self?.currentPage += 1
              self?.page?.content.append(contentsOf: page.content)
              DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.hideActivityIndicator()
                self?.isLoadingDataPage = false // Снимаем флаг после завершения загрузки
              }
            case .failure(let error):
              print(error.localizedDescription)
              self?.isLoadingDataPage = false // Снимаем флаг при ошибке
            }
          }
        }
      }
    }
  }
}
