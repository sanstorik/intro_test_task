//
//  EmptyView.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import UIKit

struct EmptyViewModel {
  let title: String?
  let message: String?
  let actionTitle: String?
  let action: (() -> Void)?
}

final class EmptyView: UIView {
  
  // MARK: - Properties
  
  let titleLabel = UILabel()
  let messageLabel = UILabel()
  let actionButton = UIButton(type: .system)
  private let stackView = UIStackView()
  
  private var viewModel: EmptyViewModel?
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public methods
  
  func setViewModel(_ viewModel: EmptyViewModel) {
    self.viewModel = viewModel
    titleLabel.text = viewModel.title
    messageLabel.text = viewModel.message
    actionButton.setTitle(viewModel.actionTitle, for: .normal)
    actionButton.isHidden = viewModel.actionTitle == nil
  }
  
  // MARK: - Private methods
  
  private func setupViews() {
    addSubview(stackView)
    
    stackView.axis = .vertical
    stackView.spacing = 10
    
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    [titleLabel, messageLabel, actionButton].forEach {
      stackView.addArrangedSubview($0)
    }
    
    [titleLabel, messageLabel].forEach {
      $0.textAlignment = .center
      $0.numberOfLines = 0
    }
    
    actionButton.addTarget(self, action: #selector(didSelectActionButton), for: .touchUpInside)
  }
  
  @objc private func didSelectActionButton() {
    viewModel?.action?()
  }
}
