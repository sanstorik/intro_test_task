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
  
  func testInitialLoad() {
    
    var loaderCalls = [Bool]()
    
    view.didShowLoader = {
      loaderCalls.append($0)
    }
    
    let reload = expectation(description: "reload")
    view.didReloadList = { type in
      reload.fulfill()
      
      switch type {
      case .pagination:
        assertionFailure()
      default:
        break
      }
    }
    
    logicController.loadInitialArtObjects()
    XCTAssertEqual(dataSource.objects.count, 1)
    XCTAssertEqual(dataSource.objects.last?.title, "1")
    XCTAssertEqual(loaderCalls, [true, false])
    
    wait(for: [reload], timeout: 0.1)
  }
  
  func testInitialLoadError() {
    /* Empty */
  }
  
  func testInitialEmptyState() {
    /* Empty */
  }
  
  func testPaginationCall() throws {
    let reload = expectation(description: "called reload")
    view.didReloadList = { type in
      switch type {
      case .full:
        assertionFailure()
      case .pagination(let newElements):
        XCTAssertEqual(newElements, 1)
      }
      
      reload.fulfill()
    }
    
    let hideError = expectation(description: "hide error")
    view.didHideErrorState = {
      hideError.fulfill()
    }
    
    _ = pagination.loadNextPageIfNeededFor(itemIndex: 2)
    XCTAssertEqual(dataSource.objects.count, 2)
    XCTAssertEqual(dataSource.objects.last?.title, "2")
    
    wait(for: [reload, hideError], timeout: 0.1)
  }
  
  func testPaginationErrorCall() throws {
    /* Empty */
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
