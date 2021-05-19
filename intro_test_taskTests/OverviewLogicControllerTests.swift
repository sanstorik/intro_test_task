//
//  OverviewLogicControllerTests.swift
//  intro_test_taskTests
//
//  Created by LIL SUNSTORY on 17.05.21.
//

import Foundation
import XCTest
import Moya

@testable import intro_test_task

class OverviewLogicControllerTests: XCTestCase {
  
  private var logicController: OverviewLogicController!
  private var requestProvider: NetworkRequestProvider<ArtObjectsService>!
  private var view: OverviewViewMock!
  private var dataSource: OverviewDataSourceProtocol!
  private var pagination: PaginationProvider!
  
  override func setUp() {
    super.setUp()
    
    let moya = MoyaProvider<ArtObjectsService>(stubClosure: MoyaProvider.immediatelyStub)
    requestProvider = NetworkRequestProvider(provider: moya)
    view = OverviewViewMock()
    dataSource = OverviewDataSourceMock()
    pagination = PaginationProvider(options: .init(itemsPerPage: 2, threshold: 0.5))
    
    logicController = OverviewLogicController()
    logicController.dataSource = dataSource
    logicController.requestProvider = requestProvider
    logicController.view = view
    logicController.paginationProvider = pagination
    
    pagination.delegate = logicController
  }
  
  func testReloadingListOnLoad() {
    
    // Given
    
    var loaderTypes = [PaginationProvider.LoadingType]()
    
    view.didReloadList = {
      loaderTypes.append($0)
    }
    
    // When
    
    logicController.loadInitialArtObjects()
    _ = pagination.loadNextPageIfNeededFor(itemIndex: 2)
    
    // Then
    
    XCTAssertEqual(loaderTypes, [.full, .pagination(newElementsCount: 1)])
  }
  
  func testAddingInitialNewElements() {
    
    // When
    
    logicController.loadInitialArtObjects()
    
    // Then
    
    XCTAssertEqual(dataSource.objects.count, 1)
    XCTAssertEqual(dataSource.objects.last?.title, "1")
  }
  
  func testAddingPaginationNewElements() {
    
    // Given
    
    let nextPageIndex = pagination.currentPage + 1
    
    // When
    
    _ = pagination.loadNextPageIfNeededFor(itemIndex: nextPageIndex)
    
    // Then
    
    XCTAssertEqual(dataSource.objects.count, 2)
    XCTAssertEqual(dataSource.objects.last?.title, String(nextPageIndex))
  }
  
  func testHidingErrorStateOnLoad() {
    
    // Given
    
    let nextPageIndex = pagination.currentPage + 1
    let hideErrorCall = expectation(description: "hide error")
    hideErrorCall.expectedFulfillmentCount = 2
    
    view.didHideErrorState = {
      hideErrorCall.fulfill()
    }
    
    // When
    
    logicController.loadInitialArtObjects()
    _ = pagination.loadNextPageIfNeededFor(itemIndex: nextPageIndex)
    
    // Then
    
    wait(for: [hideErrorCall], timeout: 0.1)
    
  }
}

private class OverviewDataSourceMock: OverviewDataSourceProtocol {
  var objects = [ArtObject(objectNumber: "1", title: nil, hasImage: nil, principalOrFirstMaker: nil, webImage: nil)]
}

private class OverviewViewMock: OverviewView {
  
  var didShowLoader: ((Bool) -> Void)?
  var didReloadList: ((PaginationProvider.LoadingType) -> Void)?
  var didHideErrorState: (() -> Void)?
  
  func showLoader(_ show: Bool) {
    didShowLoader?(show)
  }
  
  func showEmptyState(_ show: Bool) {
    
  }
  
  func showErrorState(type: PaginationProvider.LoadingType) {
    
  }
  
  func hideErrorState() {
    didHideErrorState?()
  }
  
  func reloadList(type: PaginationProvider.LoadingType) {
    didReloadList?(type)
  }
}
