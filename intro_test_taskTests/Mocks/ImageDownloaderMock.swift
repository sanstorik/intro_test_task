//
//  ImageDownloaderMock.swift
//  intro_test_taskTests
//
//  Created by Vitalii Shvetsov on 17.05.2021.
//

import Foundation
import UIKit
@testable import intro_test_task

class ImageDownloaderMock: ImageDownloaderProtocol {
  
  var didSetImage: ((_ url: String?, _ size: CGSize?) -> Void)?
  
  func setImageFor(imageView: UIImageView, by url: String?, fitting size: CGSize?) {
    didSetImage?(url, size)
  }
}
