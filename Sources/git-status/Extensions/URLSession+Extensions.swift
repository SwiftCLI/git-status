//
//  URLSession+Extensions.swift
//  git-status
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation

extension URLSession {
    #if os(Linux)
    static let shared = URLSession(configuration: .default)
    #endif
}
