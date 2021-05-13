//
//  OverviewItemCell.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import UIKit
import AlamofireImage

struct OverviewViewModel {
  let title: String?
  let author: String?
  let imageUrl: String?
}

final class OverviewItemCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  static let identifier = "OverviewItemCell"
  
  private let imageView = UIImageView()
  private let labelsStackView = UIStackView()
  let titleLabel = UILabel()
  let authorLabel = UILabel()
  
  var imageDownloader: ImageDownloaderProtocol = ImageDownloader()
    
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public methods
  
  func setViewModel(_ viewModel: OverviewViewModel) {
    titleLabel.text = viewModel.title
    authorLabel.text = viewModel.author
    
    let size = OverviewDataSource.Constants.cellHeight - 15
    imageDownloader.setImageFor(imageView: imageView, by: viewModel.imageUrl, fitting: .init(width: size, height: size))
  }
  
  // MARK: - Private methods
  
  private func setupViews() {
    
    [imageView, labelsStackView].forEach {
      addSubview($0)
    }
    
    imageView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview().inset(7.5)
      make.width.equalTo(imageView.snp.height)
    }
    
    labelsStackView.snp.makeConstraints { make in
      make.centerY.equalTo(imageView.snp.centerY)
      make.top.equalTo(imageView.snp.top).priority(750)
      make.bottom.equalTo(imageView.snp.bottom).priority(750)
      make.leading.equalTo(imageView.snp.trailing).inset(-7.5)
      make.trailing.equalTo(snp.trailing).inset(7.5)
    }
    
    labelsStackView.distribution = .fillProportionally
    labelsStackView.axis = .vertical
    labelsStackView.spacing = 7.5
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(authorLabel)
    
    titleLabel.numberOfLines = 2
  }
}
