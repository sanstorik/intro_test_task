//
//  OverviewViewController.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import UIKit
import SnapKit

final class OverviewViewController: StatefulViewController {
  
  // MARK: - Properties
  
  private let itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private let logicController: OverviewLogicControllerProtocol
  private let dataSource: OverviewDataSource
  private let paginationProvider: PaginationProvider
  
  // MARK: - Initializers
  
  init(
    logicController: OverviewLogicControllerProtocol = OverviewLogicController(),
    dataSource: OverviewDataSource = OverviewDataSource(),
    router: OverviewRouterProtocol = OverviewRouter(),
    requestProvider: NetworkRequestProvider<ArtObjectsService> = NetworkRequestProvider(),
    paginationProvider: PaginationProvider = PaginationProvider(options: .default)
  ) {
    self.logicController = logicController
    self.dataSource = dataSource
    self.paginationProvider = paginationProvider
    dataSource.router = router
    logicController.requestProvider = requestProvider
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupReferences()
    view.backgroundColor = .white
    navigationItem.title = "Overview"
  }
  
  // MARK: - Private methods
  
  private func setupViews() {
    view.addSubview(itemsCollectionView)
    itemsCollectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    dataSource.applyTo(collectionView: itemsCollectionView)
    itemsCollectionView.backgroundColor = .clear
    itemsCollectionView.alwaysBounceVertical = true
    itemsCollectionView.reloadData()
  }
  
  private func setupReferences() {
    dataSource.router?.source = self
    
    paginationProvider.delegate = logicController
    dataSource.paginationProvider = paginationProvider
    logicController.paginationProvider = paginationProvider
    
    logicController.view = self
    logicController.dataSource = dataSource
    logicController.loadInitialArtObjects()
  }
  
  private func getEmptyViewModel() -> EmptyViewModel {
    return .init(title: "Empty", message: "No art objects available", actionTitle: "Reload") { [weak self] in
      self?.logicController.loadInitialArtObjects()
    }
  }
  
  private func getErrorViewModel() -> EmptyViewModel {
    return .init(title: "Error", message: "Couldn't load", actionTitle: "Reload") { [weak self] in
      self?.logicController.loadInitialArtObjects()
    }
  }
}

// MARk: - OverviewView

extension OverviewViewController: OverviewView {

  func reloadList(type: PaginationProvider.LoadingType) {
    switch type {
    case .full:
      itemsCollectionView.reloadData()
    case .pagination(let newElementsCount):
      var indexPaths = [IndexPath]()
      
      for i in dataSource.objects.count - newElementsCount..<dataSource.objects.count {
        indexPaths.append(.init(row: i, section: 0))
      }
      
      itemsCollectionView.insertItems(at: indexPaths)
    }
  }
  
  func showLoader(_ show: Bool) {
    show ? view.showLoader() : view.removeLoader()
  }
  
  func showErrorState(type: PaginationProvider.LoadingType) {
    switch type {
    case .full:
      showEmptyView(true, viewModel: getErrorViewModel())
    case .pagination:
      showErrorNotification()
    }
  }
  
  private func showErrorNotification() {
    /* Empty */
  }
  
  func hideErrorState() {
    showEmptyView(false, viewModel: getEmptyViewModel())
  }
  
  func showEmptyState(_ show: Bool) {
    showEmptyView(true, viewModel: getEmptyViewModel())
  }
}
