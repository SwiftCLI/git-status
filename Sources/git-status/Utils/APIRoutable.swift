//
//  APIRoutable.swift
//  bucket-status
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation
import Alamofire

public enum APIRoutableError: Swift.Error {
  case invalidURL(url: String)
  case parameterEncodingFailed(error: Error)
}

public enum APIRoutableParameters {
  case dictionary([String: Any])
  case encodable(Encodable)
  case data(Data)

  var dictionary: [String: Any]? {
    switch self {
    case let .dictionary(dict):
      return dict

    case let .encodable(encodable):
      return encodable.convertToDictionary(options: [])

    default:
      return nil
    }
  }
}

public protocol APIRoutable: URLRequestConvertible {
  /// Path for each API
  var path: String { get }

  /// Body parameter for HTTP call (e.g. JSON POST body)
  var parameters: APIRoutableParameters? { get }

  /// HTTP Method will use for each API
  var method: HTTPMethod { get }

  /// Base URL for each API
  var urlHost: String { get }

  /// Additional headers for each API
  var headers: [HTTPHeader] { get }

  /// Query parameters
  var query: [String: String]? { get }

  /// Cache policy for API, defaults to `.useProtocolCachePolicy`
  var cachePolicy: URLRequest.CachePolicy { get }

  /// Timeout interval for API in seconds, defaults to 60 seconds.
  var timeoutInterval: TimeInterval { get }

  /// Should authenticate
  var shouldAuthenticate: Bool { get }
}

public extension APIRoutable {
  /// Should authenticate
  var shouldAuthenticate: Bool { return false }

  /// Cache policy for API, defaults to `.useProtocolCachePolicy`
  var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }

  /// Timeout interval for API in seconds, defaults to 60 seconds.
  var timeoutInterval: TimeInterval { return 60 }

  /// Convert `APIRouter` into `URLRequest`
  func asURLRequest() throws -> URLRequest {
    guard let url = URL(string: urlHost),
      let apiUrl = URL(string: path, relativeTo: url),
      var urlComponents = URLComponents(url: apiUrl, resolvingAgainstBaseURL: true)
    else {
      throw APIRoutableError.invalidURL(url: path)
    }

    // HTTP query items
    urlComponents.queryItems = query?.map { URLQueryItem(name: $0, value: $1) }

    guard let urlComponentsURL = urlComponents.url else {
      throw APIRoutableError.invalidURL(url: path)
    }

    var urlRequest = URLRequest(url: urlComponentsURL,
                                cachePolicy: cachePolicy,
                                timeoutInterval: timeoutInterval)
    // HTTP Method
    urlRequest.httpMethod = method.rawValue

    // Common Headers
    let commonHeaders: [HTTPHeader] = [
        HTTPHeader.contentType(HTTPContentType.json.rawValue),
        HTTPHeader.accept(HTTPContentType.json.rawValue)
    ]

    // Additinal Headers from Router
    let allHeaders = commonHeaders + headers
    for header in allHeaders {
      urlRequest.setValue(header.value,
                          forHTTPHeaderField: header.name)
    }

    // Parameters
    if case let .data(data) = parameters {
      urlRequest.httpBody = data
    } else if let parameters = parameters?.dictionary {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters,
                                                         options: [])
      } catch {
        throw APIRoutableError.parameterEncodingFailed(error: error)
      }
    }

    return urlRequest
  }
}

/// MIME type
///
/// See https://tools.ietf.org/html/rfc6838
public typealias MIMEType = String

/// Defines HTTP content type based on standard MIMETypes
public enum HTTPContentType: Hashable, RawRepresentable, Comparable {
  public static func < (lhs: HTTPContentType, rhs: HTTPContentType) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

  /// JSON type: `application/json`
  case json

  /// URL encoded form: `application/x-www-form-urlencoded`
  case form

  /// Multipart form data: `multipart/form-data; boundary=`
  case multipart(String)

  public typealias RawValue = MIMEType

  public init?(rawValue: HTTPContentType.RawValue) {
    switch rawValue {
    case "application/json": self = .json
    case "application/x-www-form-urlencoded": self = .form
    default: return nil
    }
  }

  public var rawValue: HTTPContentType.RawValue {
    switch self {
    case .json: return "application/json"
    case .form: return "application/x-www-form-urlencoded"
    case let .multipart(boundary): return "multipart/form-data; boundary=\(boundary)"
    }
  }
}
