//
//  OverviewLogicController.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import Foundation
import Moya

protocol OverviewView: AnyObject {
  func showLoader(_ show: Bool)
  func showEmptyState(_ show: Bool)
  func showErrorState(type: PaginationProvider.LoadingType)
  func hideErrorState()
  func reloadList(type: PaginationProvider.LoadingType)
}

protocol OverviewLogicControllerProtocol: PaginationProviderDelegate {
  var view: OverviewView? { get set }
  var dataSource: OverviewDataSourceProtocol? { get set }
  var requestProvider: NetworkRequestProvider<ArtObjectsService>? { get set }
  var paginationProvider: PaginationProvider? { get set }
  
  func loadInitialArtObjects()
}

final class OverviewLogicController: OverviewLogicControllerProtocol {
  
  // MARK: - Properties
  
  weak var view: OverviewView?
  var dataSource: OverviewDataSourceProtocol?
  var requestProvider: NetworkRequestProvider<ArtObjectsService>?
  var paginationProvider: PaginationProvider?
  
  // MARK: - Public methods
  
  func loadInitialArtObjects() {
    
    guard let paginationProvider = paginationProvider else {
      return
    }
    
    paginationProvider.resetPagination()
    view?.showLoader(true)
    
    loadArtObjects(for: listParams(for: paginationProvider)) { [weak self] (result: Result<GalleryResponse, Error>) in
      guard let self = self else {
        return
      }
      
      switch result {
      case .success(let response):
        guard response.count > 0 else {
          self.view?.showEmptyState(true)
          return
        }
        
        self.dataSource?.objects = response.artObjects
        self.view?.hideErrorState()
        self.view?.reloadList(type: .full)
      case .failure:
        self.view?.showErrorState(type: .full)
      }
      
      self.view?.showLoader(false)
    }
  }
  
  // MARK: - Private methods
  
  private func loadArtObjects(for params: GalleryListParams, completionHandler: @escaping (Result<GalleryResponse, Error>) -> Void) {
    requestProvider?.request(ArtObjectsService.galleryList(params), completion: completionHandler)
  }
  
  private func listParams(for provider: PaginationProvider) -> GalleryListParams {
    return .init(page: provider.currentPage, itemsPerPage: provider.options.itemsPerPage)
  }
  
  private func listParams(for page: Int) -> GalleryListParams {
    return .init(page: page, itemsPerPage: paginationProvider?.options.itemsPerPage ?? 0)
  }
}

// MARK: - PaginationProviderDelegate

extension OverviewLogicController {
  
  func paginationLoadNextPage(completionHandler: @escaping (Int?) -> Void) {
    
    guard let paginationProvider = paginationProvider else {
      return
    }
    
    loadArtObjects(for: listParams(for: paginationProvider.currentPage + 1)) { [weak self] result in
      guard let newObjects = try? result.get().artObjects else {
        completionHandler(nil)
        return
      }
      
      self?.dataSource?.objects += newObjects
      completionHandler(newObjects.count)
    }
  }
  
  func paginationDidFinish(with newElements: Int?) {
    
    guard let view = view else {
      return
    }
    
    guard let newElements = newElements else {
      view.showErrorState(type: .pagination(newElementsCount: 0))
      return
    }
    
    view.hideErrorState()
    view.reloadList(type: .pagination(newElementsCount: newElements))
  }
}
