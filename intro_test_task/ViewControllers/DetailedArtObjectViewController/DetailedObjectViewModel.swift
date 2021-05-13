//
//  DetailedObjectViewModel.swift
//  intro_test_task
//
//  Created by LIL SUNSTORY on 16.05.21.
//

import Foundation

struct DetailedObjectViewModel {
  let location: String?
  let titles: [String]
  let authors: [String]
  let webImage: WebImage?
  let objectNumber: String
}

protocol DetailedObjectMapperProtocol {
  func transform(object: DetailedArtObject) -> DetailedObjectViewModel
}

struct DetailedObjectViewModelMapper: DetailedObjectMapperProtocol {
  
  func transform(object: DetailedArtObject) -> DetailedObjectViewModel {
    return .init(
      location: object.location.flatMap { "Located in \($0)" },
      titles: object.titles ?? [],
      authors: (object.principalMakers ?? []).compactMap {
        let res = Array([$0.name, $0.placeOfBirth]).compactMap { $0 }.joined(separator: " - ")
        return res.isEmpty ? nil : "by \(res)"
      },
      webImage: object.webImage,
      objectNumber: object.objectNumber
    )
  }
}
