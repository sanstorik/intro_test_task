//
//  DetailedViewControllerTests.swift
//  intro_test_taskUITests
//
//  Created by Vitalii Shvetsov on 17.05.2021.
//

import UIKit
import XCTest
@testable import intro_test_task

class DetailedViewControllerTests: XCTestCase {
  
  var imageDownloader: ImageDownloaderMock!
  fileprivate var logicController: LogicControllerMock!
  
  override func setUp() {
    super.setUp()
    imageDownloader = ImageDownloaderMock()
    logicController = LogicControllerMock()
  }
  
  func testLoadingImage() {
    
    // Given
    
    let viewModel = getViewModel()
    logicController.loadDetailedObject = { [weak logicController] in
      logicController?.view?.displayObject(viewModel)
    }
    
    var setImageUrl: String?
    
    imageDownloader.didSetImage = { url, _ in
      setImageUrl = url
    }
    
    // When
    
    let vc = createViewController(image: viewModel.webImage)
    vc.loadViewIfNeeded()
    
    // Then
    
    XCTAssertEqual(setImageUrl, viewModel.webImage?.url)
  }
  
  func testCreatingPropeLabels() {
    
    // Given
    
    let viewModel = getViewModel()
    logicController.loadDetailedObject = { [weak logicController] in
      logicController?.view?.displayObject(viewModel)
    }
    
    let expectedTitles = [
      viewModel.objectNumber,
      viewModel.location,
      viewModel.titles[0],
      viewModel.titles[1],
      viewModel.authors[0],
      viewModel.authors[1]
    ]
    
    // When
    
    let vc = createViewController(image: viewModel.webImage)
    vc.loadViewIfNeeded()
    
    // Then
    
    guard vc.dataStackView.arrangedSubviews.count == 1 + expectedTitles.count else {
      assertionFailure()
      return
    }
    
    XCTAssertTrue(vc.dataStackView.arrangedSubviews[0] is UIImageView)
    
    for i in 1..<vc.dataStackView.arrangedSubviews.count {
      XCTAssertEqual((vc.dataStackView.arrangedSubviews[i] as? UILabel)?.text, expectedTitles[i - 1])
    }
  }
  
  func testShowingErrorState() {
    
    // Given
    
    logicController.loadDetailedObject = { [weak logicController] in
      logicController?.view?.showError(true)
    }
    
    // When
    
    let vc = createViewController(image: nil)
    vc.loadViewIfNeeded()
    
    // Then
    
    XCTAssertTrue(vc.isShowingEmptyView())
  }
  
  func testInitialErrorState() {
    
    // When
    
    let vc = createViewController(image: nil)
    vc.loadViewIfNeeded()
    
    // Then
    
    XCTAssertFalse(vc.isShowingEmptyView())
  }
  
  // MARK: - Helper methods
  
  private func getViewModel() -> DetailedObjectViewModel {
    
    return DetailedObjectViewModel(location: "location",
                                   titles: ["one", "two"],
                                   authors: ["a1", "a2"],
                                   webImage: .init(guid: "guid", url: "url"),
                                   objectNumber: "number")
  }
  
  private func createViewController(image: WebImage?) -> DetailedArtObjectViewController {
    return DetailedArtObjectViewController(
      artObject: .init(objectNumber: "", title: nil, hasImage: nil, principalOrFirstMaker: nil, webImage: image),
      imageDownloader: imageDownloader,
      logicController: logicController
    )
  }
}

private class LogicControllerMock: DetailedArtObjectLogicControllerProtocol {
  weak var view: DetailedArtObjectView?
  var loadDetailedObject: (() -> Void)?
  
  func loadDetailedArtObjectFor(artObject: ArtObject) {
    loadDetailedObject?()
  }
}
