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
  
  func testSettingViewModel() {
    
    // Given
    
    let viewModel = OverviewViewModel(title: "title", author: "author", imageUrl: "url")
    var setImageUrl: String?
    imageDownloader.didSetImage = { url, _ in
      setImageUrl = url
    }
    
    // When
    
    cell.setViewModel(viewModel)
    
    // Then
    
    XCTAssertEqual(cell.titleLabel.text, viewModel.title)
    XCTAssertEqual(cell.authorLabel.text, viewModel.author)
    XCTAssertEqual(setImageUrl, viewModel.imageUrl)
  }
}
