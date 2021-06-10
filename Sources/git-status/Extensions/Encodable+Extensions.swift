//
//  Encodable+Extensions.swift
//  bucket-status
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation

public extension Encodable {
  func convertToDictionary(options: JSONSerialization.ReadingOptions = .allowFragments) -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(self),
      let dict = try? JSONSerialization.jsonObject(with: data, options: options) else {
      return nil
    }

    return dict as? [String: Any]
  }
}
