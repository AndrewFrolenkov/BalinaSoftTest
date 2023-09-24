//
//  NetworkService.swift
//  BalinaSoftTest
//
//  Created by Андрей Фроленков on 24.09.23.
//

import Foundation
import UIKit

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
  
  func uploadPhoto(name: String, photo: UIImage, typeId: Int, completion: @escaping (Bool, Error?) -> Void) {
      guard let imageData = photo.jpegData(compressionQuality: 0.8) else {
          // Обработка ошибки, если не удается преобразовать изображение в данные
          completion(false, NSError(domain: "YourAppDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Ошибка преобразования изображения в данные"]))
          return
      }
      
      let url = URL(string: "https://junior.balinasoft.com/api/v2/photo")!
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      
      // Создаем уникальный разделитель (boundary)
      let boundary = UUID().uuidString
      
      // Устанавливаем параметры запроса в формате multipart/form-data
      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
      
      var body = Data()
      
      // Добавляем параметры в тело запроса
      body.append("--\(boundary)\r\n".data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
      body.append("\(name)\r\n".data(using: .utf8)!)
      
      body.append("--\(boundary)\r\n".data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
      body.append("\(typeId)\r\n".data(using: .utf8)!)
      
      // Добавляем изображение в тело запроса
      body.append("--\(boundary)\r\n".data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
      body.append(imageData)
      body.append("\r\n".data(using: .utf8)!)
      
      // Завершаем тело запроса
      body.append("--\(boundary)--\r\n".data(using: .utf8)!)
      
      request.httpBody = body
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
              // Обработка ошибки
              print("Error: \(error)")
              completion(false, error)
              return
          }
          
          if let httpResponse = response as? HTTPURLResponse {
              if httpResponse.statusCode == 200 {
                  // Если статус код 200, это означает успешный ответ от сервера
                  print("Фотография успешно загружена на сервер.")
                  completion(true, nil)
              } else {
                  // Если статус код не 200, это означает ошибку на сервере
                  print("Ошибка при загрузке фотографии. Статус код: \(httpResponse.statusCode)")
                  completion(false, NSError(domain: "YourAppDomain", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Ошибка загрузки фотографии"]))
              }
          }
      }
      
      task.resume()
  }
  
}
