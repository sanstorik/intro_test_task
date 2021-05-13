//
//  GalleryResponse.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import Foundation

struct GalleryResponse: Codable {
  let count: Int
  let artObjects: [ArtObject]
}
