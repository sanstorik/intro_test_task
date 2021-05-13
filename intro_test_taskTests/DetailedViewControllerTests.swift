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
  
  func testSettingInitialData() {
    
    let viewModel = DetailedObjectViewModel(location: "location",
                                            titles: ["one", "two"],
                                            authors: ["a1", "a2"],
                                            webImage: .init(guid: "guid", url: "url"),
                                            objectNumber: "number")
    
    logicController.viewModel = viewModel
    
    let didSetImage = expectation(description: "image")
    imageDownloader.didSetImage = { url, _ in
      didSetImage.fulfill()
      XCTAssertEqual(url, viewModel.webImage?.url)
    }
    
    let vc = createViewController(image: viewModel.webImage)
    vc.loadViewIfNeeded()
    
    let expectedTitles = [
      viewModel.objectNumber,
      viewModel.location,
      viewModel.titles[0],
      viewModel.titles[1],
      viewModel.authors[0],
      viewModel.authors[1]
    ]
    
    guard vc.dataStackView.arrangedSubviews.count == 1 + expectedTitles.count else {
      assertionFailure()
      return
    }
    
    XCTAssertTrue(vc.dataStackView.arrangedSubviews[0] is UIImageView)
    
    for i in 1..<vc.dataStackView.arrangedSubviews.count {
      XCTAssertEqual((vc.dataStackView.arrangedSubviews[i] as? UILabel)?.text, expectedTitles[i - 1])
    }
    
    wait(for: [didSetImage], timeout: 0.1)
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
  var view: DetailedArtObjectView?
  var viewModel: DetailedObjectViewModel!
  
  func loadDetailedArtObjectFor(artObject: ArtObject) {
    view?.displayObject(viewModel)
  }
}
