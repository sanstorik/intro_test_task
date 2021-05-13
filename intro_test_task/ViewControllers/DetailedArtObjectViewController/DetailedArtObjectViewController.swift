//
//  DetailedArtObjectViewController.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import UIKit

final class DetailedArtObjectViewController: StatefulViewController {
  
  // MARK: - Properties
  
  let dataStackView = UIStackView()
  private let artObject: ArtObject
  private let avatarImageView = UIImageView()
  private let scrollView = UIScrollView()
  private let imageDownloader: ImageDownloaderProtocol
  private let logicController: DetailedArtObjectLogicControllerProtocol
  
  // MARK: - Initializers
  
  init(
    artObject: ArtObject,
    imageDownloader: ImageDownloaderProtocol = ImageDownloader(),
    logicController: DetailedArtObjectLogicControllerProtocol =
      DetailedArtObjectLogicController(requestProvider: NetworkRequestProvider(), mapper: DetailedObjectViewModelMapper())
  ) {
    self.artObject = artObject
    self.imageDownloader = imageDownloader
    self.logicController = logicController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = artObject.title
    view.backgroundColor = .white
    setupViews()
    logicController.loadDetailedArtObjectFor(artObject: artObject)
  }
  
  // MARK: - Private methods
  
  private func setupReferences() {
    logicController.view = self
  }
  
  private func setupViews() {
    setupScrollView()
    setupStackView()
    setupReferences()
  }
  
  private func setupScrollView() {
    
    view.addSubview(scrollView)
    
    scrollView.alwaysBounceVertical = true
    scrollView.addSubview(dataStackView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    let scrollableView = UIView()
    scrollView.addSubview(scrollableView)
    scrollableView.addSubview(dataStackView)
    
    scrollableView.snp.makeConstraints { make in
      make.edges.centerX.equalToSuperview()
    }
  }
  
  private func setupStackView() {
    
    dataStackView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.bottom.equalToSuperview().priority(749)
    }
    
    dataStackView.axis = .vertical
    dataStackView.distribution = .equalSpacing
    dataStackView.spacing = 5
    setupContentViews()
  }
  
  private func setupContentViews() {
    avatarImageView.contentMode = .scaleAspectFit
    imageDownloader.setImageFor(imageView: avatarImageView, by: artObject.webImage?.url, fitting: nil)
  }
  
  private func errorViewModel() -> EmptyViewModel {
    return .init(title: "Error", message: "Couldn't fetch data", actionTitle: "Reload") { [weak self] in
      guard let self = self else {
        return
      }
      
      self.logicController.loadDetailedArtObjectFor(artObject: self.artObject)
    }
  }
}

// MARK: - DetailedArtObjectView

extension DetailedArtObjectViewController: DetailedArtObjectView {
  
  func showError(_ show: Bool) {
    showEmptyView(show, viewModel: errorViewModel())
  }
  
  func showLoader(_ show: Bool) {
    show ? view.showLoader() : view.removeLoader()
  }
  
  func displayObject(_ object: DetailedObjectViewModel) {
    
    dataStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    
    dataStackView.addArrangedSubview(avatarImageView)
    avatarImageView.snp.remakeConstraints { make in
      make.height.equalTo(view.snp.height).multipliedBy(0.35)
    }
    
    let labels = [createLabel(with: object.objectNumber)]
      + [createLabel(with: object.location)]
      + object.titles.map { createLabel(with: $0) }
      + object.authors.map { createLabel(with: $0) }
    
    labels.compactMap { $0 }.forEach {
      dataStackView.addArrangedSubview($0)
    }
    
    dataStackView.setCustomSpacing(15, after: avatarImageView)
  }
  
  private func createLabel(with text: String?) -> UILabel? {
    
    return text.flatMap {
      let label = UILabel()
      label.text = $0
      label.textAlignment = .center
      label.numberOfLines = 3
      return label
    }
  }
}
