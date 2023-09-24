//
//  Page.swift
//  BalinaSoftTest
//
//  Created by Андрей Фроленков on 24.09.23.
//

import Foundation

struct Page: Decodable {
  var content: [PhotoTypeDtoOut]
  let page: Int
  let pageSize: Int
  let totalElements: Int
  let totalPages: Int
}

struct PhotoTypeDtoOut: Decodable {
  let id: Int
  let name: String
  let image: String?
}
