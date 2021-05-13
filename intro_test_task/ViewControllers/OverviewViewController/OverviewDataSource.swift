//
//  OverviewDataSource.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import UIKit

protocol OverviewDataSourceProtocol: AnyObject {
  var objects: [ArtObject] { get set }
}

final class OverviewDataSource: NSObject, OverviewDataSourceProtocol {
  
  struct Constants {
    static let cellHeight: CGFloat = 100
    static let headerHeight: CGFloat = 50
  }
  
  var objects = [ArtObject]()
  var headerViewModel: OverviewHeaderViewModel = .init(title: "Art objects from the gallery")
  var router: OverviewRouterProtocol?
  var paginationProvider: PaginationProvider?
  
  func applyTo(collectionView: UICollectionView) {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(OverviewItemCell.self, forCellWithReuseIdentifier: OverviewItemCell.identifier)
    collectionView.register(
      OverviewItemHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OverviewItemHeader.identifier
    )
  }
}

// MARK: - TableViewDataSource + Delegate

extension OverviewDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return objects.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OverviewItemCell.identifier, for: indexPath
    ) as? OverviewItemCell else {
      fatalError()
    }
    
    let object = objects[indexPath.row]
    cell.setViewModel(
      .init(
        title: Array([object.objectNumber, object.title]).compactMap { $0 }.joined(separator: ", "),
        author: object.principalOrFirstMaker,
        imageUrl: (object.hasImage ?? true) ? object.webImage?.url : nil
      )
    )
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: OverviewItemHeader.identifier, for: indexPath
    ) as? OverviewItemHeader else {
      return UICollectionReusableView()
    }
    
    view.setViewModel(headerViewModel)
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    router?.navigateToDetailedPage(with: objects[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    _ = paginationProvider?.loadNextPageIfNeededFor(itemIndex: indexPath.row)
  }
}

// MARK: - Flow layout

extension OverviewDataSource: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: collectionView.frame.width, height: Constants.cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: collectionView.frame.width, height: Constants.headerHeight)
  }
}
