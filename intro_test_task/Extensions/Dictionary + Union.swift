//
//  Dictionary + Union.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 14.05.2021.
//

import Foundation

extension Dictionary {
  
  func createUnion(with another: Dictionary<Key, Value>) -> Dictionary {
    var result = self
    
    for (key, element) in another {
      result[key] = element
    }
    
    return result
  }
}
