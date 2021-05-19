//
//  PaginationTests.swift
//  intro_test_taskTests
//
//  Created by LIL SUNSTORY on 17.05.21.
//

import Foundation
import XCTest
@testable import intro_test_task

class PaginationTests: XCTestCase {
  
  var paginationProvider: PaginationProvider!
  fileprivate var delegate: PaginationProviderDelegateMock!
  
  func testFinishingLoadingNextPage() {
    
    // Given
    
    let newElementsCount = 20
    setupProvider(options: .default)
    
    delegate.paginationLoadBatch = newElementsCount
    let didEndPagination = expectation(description: "pagination finish")
    
    var loadedElementsCount: Int?
    delegate.didEndPagination = { elements in
      didEndPagination.fulfill()
      loadedElementsCount = elements
    }
    
    // When
    
    let isPaginationNeeded = paginationProvider.loadNextPageIfNeededFor(itemIndex: 16)
    
    // Then
    
    wait(for: [didEndPagination], timeout: 0.1)
    XCTAssertTrue(isPaginationNeeded)
    XCTAssertEqual(loadedElementsCount, newElementsCount)
  }
  
  func testRunningPaginationProperties() {
    
    // Given
    
    setupProvider(options: .default)
    let initialRunningState = paginationProvider.isRequestRunning
    var loadingState = false
      
    delegate.loadingNext = {
      loadingState = self.paginationProvider.isRequestRunning
    }
    
    // When
   
    _ = paginationProvider.loadNextPageIfNeededFor(itemIndex: 16)
    
    // Then
    
    XCTAssertFalse(initialRunningState)
    XCTAssertFalse(paginationProvider.didEndPagination)
    XCTAssertTrue(loadingState)
  }
  
  func testLastPaginationProperties() {
    
    // Given
    
    setupProvider(options: .default)
    delegate.paginationLoadBatch = 15
    let initialState = paginationProvider.didEndPagination
    
    // When
    
    _ = paginationProvider.loadNextPageIfNeededFor(itemIndex: 16)
    
    // Then
    
    XCTAssertFalse(initialState)
    XCTAssertTrue(paginationProvider.didEndPagination)
  }
  
  private func setupProvider(options: PaginationOptions) {
    delegate = PaginationProviderDelegateMock()
    paginationProvider = PaginationProvider(options: .default)
    paginationProvider.delegate = delegate
  }
}

private class PaginationProviderDelegateMock: PaginationProviderDelegate {
  
  var paginationLoadBatch: Int?
  var loadingNext: (() -> Void)?
  var didEndPagination: ((Int?) -> Void)?
  
  func paginationLoadNextPage(completionHandler: @escaping (Int?) -> Void) {
    loadingNext?()
    completionHandler(paginationLoadBatch)
  }
  
  func paginationDidFinish(with newElements: Int?) {
    didEndPagination?(newElements)
  }
}
