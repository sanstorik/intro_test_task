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
  
  func testSequence() {
    setupProvider(options: .default)
    
    delegate.paginationLoadBatch = 20
    
    XCTAssertFalse(paginationProvider.isRequestRunning)
    delegate.loadingNext = {
      XCTAssertTrue(self.paginationProvider.isRequestRunning)
    }
    
    let didEndPagination = expectation(description: "pagination finish")
    delegate.didEndPagination = { elements in
      XCTAssertEqual(elements, 20)
      didEndPagination.fulfill()
    }
    
    XCTAssertTrue(paginationProvider.loadNextPageIfNeededFor(itemIndex: 16))
    wait(for: [didEndPagination], timeout: 0.1)
  }
  
  func testLastSequence() {
    setupProvider(options: .default)
    
    delegate.paginationLoadBatch = 15
    
    _ = paginationProvider.loadNextPageIfNeededFor(itemIndex: 16)
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
