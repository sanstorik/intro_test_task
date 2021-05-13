//
//  DetailedArtObjectLogicController.swift
//  intro_test_task
//
//  Created by LIL SUNSTORY on 16.05.21.
//

import Foundation

protocol DetailedArtObjectView: AnyObject {
  func showLoader(_ show: Bool)
  func showError(_ show: Bool)
  func displayObject(_ object: DetailedObjectViewModel)
}

protocol DetailedArtObjectLogicControllerProtocol: AnyObject {
  var view: DetailedArtObjectView? { get set }
  func loadDetailedArtObjectFor(artObject: ArtObject)
}

final class DetailedArtObjectLogicController: DetailedArtObjectLogicControllerProtocol {
  
  // MARK: - Properties
  
  weak var view: DetailedArtObjectView?
  private let requestProvider: NetworkRequestProvider<ArtObjectsService>
  private let mapper: DetailedObjectMapperProtocol
  
  // MARK: - Initializers
  
  init(requestProvider: NetworkRequestProvider<ArtObjectsService>, mapper: DetailedObjectMapperProtocol) {
    self.requestProvider = requestProvider
    self.mapper = mapper
  }
  
  // MARK: - Public methods
  
  func loadDetailedArtObjectFor(artObject: ArtObject) {
    
    let detailedRequest = ArtObjectsService.detailedArtObject(id: artObject.objectNumber)
    view?.showLoader(true)
    requestProvider.request(detailedRequest) { [weak self] (result: Result<DetailedArtObjectResponse, Error>) in
      
      defer {
        self?.view?.showLoader(false)
      }
      
      guard let self = self, let view = self.view else {
        return
      }
      
      switch result {
      case .success(let artObject):
        view.showError(false)
        view.displayObject(self.mapper.transform(object: artObject.artObject))
      case .failure:
        view.showError(true)
      }
    }
  }
}
