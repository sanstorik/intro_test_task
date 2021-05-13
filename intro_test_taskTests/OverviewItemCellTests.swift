//
//  OverviewItemCellTests.swift
//  intro_test_taskTests
//
//  Created by Vitalii Shvetsov on 17.05.2021.
//

import UIKit
import XCTest
@testable import intro_test_task

class OverviewItemCellTests: XCTestCase {
  
  var cell: OverviewItemCell!
  var imageDownloader: ImageDownloaderMock!
  
  override func setUp() {
    super.setUp()
    cell = OverviewItemCell()
    imageDownloader = ImageDownloaderMock()
    cell.imageDownloader = imageDownloader
  }
  
  func testViewModel() {
    
    let viewModel = OverviewViewModel(title: "title", author: "author", imageUrl: "url")
    let imageCall = expectation(description: "image")
    
    imageDownloader.didSetImage = { url, _ in
      imageCall.fulfill()
      XCTAssertEqual(url, viewModel.imageUrl)
    }
    
    cell.setViewModel(viewModel)
    
    XCTAssertEqual(cell.titleLabel.text, viewModel.title)
    XCTAssertEqual(cell.authorLabel.text, viewModel.author)
    
    wait(for: [imageCall], timeout: 0.1)
  }
}
