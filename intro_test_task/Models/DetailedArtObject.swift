//
//  DetailedArtObject.swift
//  intro_test_task
//
//  Created by LIL SUNSTORY on 16.05.21.
//

import Foundation

struct DetailedArtObject: Codable {
  let objectNumber: String
  let title: String?
  let hasImage: Bool?
  let webImage: WebImage?
  let titles: [String]?
  let location: String?
  let principalMakers: [PrincipalMaker]?
}
