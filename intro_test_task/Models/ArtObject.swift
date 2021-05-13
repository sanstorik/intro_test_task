//
//  ArtObject.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import Foundation

struct ArtObject: Codable {
  let objectNumber: String
  let title: String?
  let hasImage: Bool?
  let principalOrFirstMaker: String?
  let webImage: WebImage?
}
