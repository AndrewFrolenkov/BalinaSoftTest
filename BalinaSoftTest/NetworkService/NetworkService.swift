//
//  NetworkService.swift
//  BalinaSoftTest
//
//  Created by Андрей Фроленков on 24.09.23.
//

import Foundation

final class NetworkService {
  
  static let shared = NetworkService()
  
  static let url = "https://junior.balinasoft.com/api/v2/photo/type"
  
  func fetchPhotoTypes(page: Int, completion: @escaping (Result<Page, Error>) -> Void) {
          let urlString = "\(NetworkService.url)?page=\(page)"

          guard let url = URL(string: urlString) else {
              completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
              return
          }

          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }

              guard let data = data else {
                  completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                  return
              }

              do {
                  let decoder = JSONDecoder()
                  let page = try decoder.decode(Page.self, from: data)
                  completion(.success(page))
              } catch {
                  completion(.failure(error))
              }
          }

          task.resume()
      }
}
