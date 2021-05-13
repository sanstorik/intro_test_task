//
//  ImageDownloader.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import AlamofireImage

protocol ImageDownloaderProtocol {
  func setImageFor(imageView: UIImageView, by url: String?, fitting size: CGSize?)
}

final class ImageDownloader: ImageDownloaderProtocol {
  
  func setImageFor(imageView: UIImageView, by url: String?, fitting size: CGSize?) {
    imageView.image = nil
    imageView.af.cancelImageRequest()
    imageView.removeLoader()
    
    guard let url = url, let networkURL = URL(string: url) else {
      return
    }
    
    imageView.showLoader(style: .clearDark, scaleByParentSize: true)
    
    imageView.af.setImage(
      withURLRequest: URLRequest(url: networkURL),
      filter: size.flatMap { AspectScaledToFillSizeFilter(size: $0) },
      completion:  { _ in
        imageView.removeLoader()
      })
  }
}
