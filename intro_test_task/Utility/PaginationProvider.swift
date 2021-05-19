//
//  PaginationProvider.swift
//  intro_test_task
//
//  Created by LIL SUNSTORY on 16.05.21.
//

import Foundation

struct PaginationOptions {
  let itemsPerPage: Int
  let threshold: Double
  
  static let `default` = PaginationOptions(itemsPerPage: 20, threshold: 0.6)
}

protocol PaginationProviderDelegate: AnyObject {
  func paginationLoadNextPage(completionHandler: @escaping (_ elementsCount: Int?) -> Void)
  func paginationDidFinish(with newElements: Int?)
}

final class PaginationProvider {
  
  // MARK: - Properties
  
  private(set) var currentPage = 1
  private(set) var didEndPagination = false
  private(set) var isRequestRunning = false
  weak var delegate: PaginationProviderDelegate?
  let options: PaginationOptions
  
  // MARK: - Initializers
  
  init(options: PaginationOptions) {
    self.options = options
  }
  
  // MARK: - Public methods
  
  func resetPagination() {
    currentPage = 1
    didEndPagination = false
  }
  
  func loadNextPageIfNeededFor(itemIndex: Int) -> Bool {
    
    guard isPaginationNeededFor(itemIndex: itemIndex) else {
      return false
    }
    
    isRequestRunning = true
    
    delegate?.paginationLoadNextPage { [weak self] newElementsCount in
      
      guard let self = self else {
        return
      }
      
      defer {
        self.delegate?.paginationDidFinish(with: newElementsCount)
        self.isRequestRunning = false
      }
      
      guard let newElementsCount = newElementsCount else {
        return
      }
      
      self.currentPage += 1
      self.didEndPagination = newElementsCount < self.options.itemsPerPage
    }
    
    return true
  }
  
  // MARK: - Private methods
  
  private func isPaginationNeededFor(itemIndex: Int) -> Bool {
    let itemIndexThatTriggersPagination = (currentPage - 1) * options.itemsPerPage + Int(Double(options.itemsPerPage) * options.threshold)
    return !isRequestRunning && !didEndPagination && itemIndex >= itemIndexThatTriggersPagination
  }
}

// MARK: - LoadingType

extension PaginationProvider {
  
  enum LoadingType: Equatable {
    case full
    case pagination(newElementsCount: Int)
    
    static func == (lhs: LoadingType, rhs: LoadingType) -> Bool {
      switch (lhs, rhs) {
      case (.full, .full):
        return true
      case (.pagination(let lhsElements), .pagination(let rhsElements)):
        return lhsElements == rhsElements
      default:
        return false
      }
    }
  }
}
