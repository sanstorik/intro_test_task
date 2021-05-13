//
//  OverviewItemHeader.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import UIKit

struct OverviewHeaderViewModel {
  let title: String
}

final class OverviewItemHeader: UICollectionReusableView {
  
  // MARK: - Properties
  
  static let identifier = "OverviewItemHeader"
  
  let titleLabel = UILabel()
  
  // MARK: - Initailizers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public methods
  
  func setViewModel(_ viewModel: OverviewHeaderViewModel) {
    titleLabel.text = viewModel.title
  }
  
  // MARK: - Private methods
  
  private func setupViews() {
    backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    titleLabel.font = UIFont(name: "AmericanTypewriter", size: 20)
  }
}
