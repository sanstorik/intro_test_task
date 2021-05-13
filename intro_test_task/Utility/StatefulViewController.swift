//
//  StatefulViewController.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import UIKit

class StatefulViewController: UIViewController {
  
  // MARK: - Properties
  
  private let holder = UIView()
  private let emptyView = EmptyView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  // MARK: - Public methods
  
  func showEmptyView(_ show: Bool, viewModel: EmptyViewModel) {
    holder.isHidden = !show
    emptyView.setViewModel(viewModel)
    view.bringSubviewToFront(holder)
  }
  
  // MARK: - Private methods
  
  private func setupViews() {
    view.addSubview(holder)
    holder.addSubview(emptyView)
    
    holder.backgroundColor = .white
    holder.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    emptyView.snp.makeConstraints { make in
      make.centerY.centerX.width.equalToSuperview()
    }
    
    holder.isHidden = true
  }
}
