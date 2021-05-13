//
//  ArtObjectsRouter.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import Foundation
import Moya

enum ArtObjectsService {
  case galleryList(GalleryListParams)
  case detailedArtObject(id: String)
}

extension ArtObjectsService: TargetType {
  
  var baseURL: URL {
    return URL(string: "https://www.rijksmuseum.nl/api/en")!
  }
  
  var path: String {
    switch self {
    case .galleryList:
      return "/collection"
    case .detailedArtObject(let id):
      return "/collection/\(id)"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Task {
    switch self {
    case .galleryList(let params):
      return .requestParameters(parameters: params.dictionary?.createUnion(with: serviceKeyParams) ?? [:],
                                encoding: URLEncoding.queryString)
    case .detailedArtObject:
      return .requestParameters(parameters: serviceKeyParams, encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json; charset=utf-8"]
  }
  
  var serviceKeyParams: [String: Any] {
    return ["key": /* insert your API key here*/ ""]
  }
  
  var sampleData: Data {
    switch self {
    case .galleryList(let params):
      return try! JSONEncoder().encode(
        GalleryResponse(
          count: params.page,
          artObjects: [
            ArtObject(objectNumber: "some", title: String(params.page), hasImage: nil, principalOrFirstMaker: nil, webImage: nil)
          ])
      )
    case .detailedArtObject:
      return try! JSONEncoder().encode(
        DetailedArtObjectResponse(artObject: .init(objectNumber: "Some",
                                                   title: nil,
                                                   hasImage: nil,
                                                   webImage: nil,
                                                   titles: nil,
                                                   location: nil,
                                                   principalMakers: nil))
      )
    }
  }
}
