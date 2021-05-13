//
//  OverviewRouter.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import UIKit

protocol OverviewRouterProtocol {
  var source: UIViewController? { get set }
  func navigateToDetailedPage(with object: ArtObject)
}

final class OverviewRouter: OverviewRouterProtocol {
  
  // MARK: - Properties
  
  var source: UIViewController?
  
  // MARK: - Public methods
  
  func navigateToDetailedPage(with object: ArtObject) {
    let detailedVC = DetailedArtObjectViewController(artObject: object)
    source?.navigationController?.pushViewController(detailedVC, animated: true)
  }
}
