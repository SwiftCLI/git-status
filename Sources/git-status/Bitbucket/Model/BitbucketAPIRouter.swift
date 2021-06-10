//
//  BucketAPIRouter.swift
//  bucket-status
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation
import Alamofire

struct BitbucketAPIRouter: APIRoutable {
    var urlHost: String {
        Constants.Host.bitbucket.rawValue
    }

    var path: String {
        Constants.Path.summary.rawValue
    }
    
    var parameters: APIRoutableParameters?
    
    var method: HTTPMethod {
        .get
    }
    
    
    var headers: [HTTPHeader] {
        []
    }
    
    var query: [String : String]?
}
