//
//  File.swift
//  bucket-status
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation
import SwiftyTextTable

struct BitbucketResponse: Codable {
    let status: Status
    let components: [Component]
}

struct Status: Codable {
    let indicator: Indicator
    let description: String
}

struct Component: Codable {
    let name: String
//    let description: String
    let position: Int
    let status: ComponentStatus
}

enum Indicator: String, CustomStringConvertible, Codable {
    case none, minor, major, critical
    
    var description: String {
        switch self {
        case .none:
            return "✅"
        case .minor:
            return "⚠️"
        case .major:
            return "🆘"
        case .critical:
            return "⛔️"
        }
    }
}

enum ComponentStatus: String, CustomStringConvertible, Codable {
    case operational
    case degradedPerformance = "degraded_performance"
    case partialOutage = "partial_outage"
    case majorOutage = "major_outage"
    
    var description: String {
        switch self {
        case .operational:
            return "Operational"
        case .degradedPerformance:
            return "Degraded Performance"
        case .majorOutage:
            return "Major Outage"
        case .partialOutage:
            return "Partial Outage"
        }
    }
}

extension Component: TextTableRepresentable {
    static var columnHeaders: [String] {
        ["Name", "Status"]
    }
    
    var tableValues: [CustomStringConvertible] {
        [name, status]
    }
}
