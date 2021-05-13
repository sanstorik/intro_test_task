//
//  GalleryListParams.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import Foundation

struct GalleryListParams: Encodable {
  let page: Int
  let itemsPerPage: Int
  
  enum CodingKeys: String, CodingKey {
    case page = "p"
    case itemsPerPage = "ps"
  }
}
