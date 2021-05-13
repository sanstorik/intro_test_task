//
//  NetworkRequestProvider.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import Foundation
import Moya

final class NetworkRequestProvider<T: TargetType> {
  
  // MARK: - Properties
  
  private let moyaProvider: MoyaProvider<T>
  
  // MARK: - Initializers
  
  init(provider: MoyaProvider<T> = .init()) {
    self.moyaProvider = provider
  }
  
  // MARK: - Public methods
  
  func request<T1: Decodable>(_ target: T, completion: @escaping (Result<T1, Error>) -> Void) {
    
    moyaProvider.request(target, completion: { result in
      switch result {
      case .success(let response):
        
        do {
          let decoded = try JSONDecoder().decode(T1.self, from: response.data)
          completion(.success(decoded))
        } catch let error {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }
}
