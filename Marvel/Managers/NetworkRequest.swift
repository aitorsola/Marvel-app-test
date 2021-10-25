//
//  NetworkManager.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation
import Alamofire

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
  case head = "HEAD"
}

enum Encoding {
  case json
  case url

  func parameterEncoding() -> ParameterEncoding {
    switch self {
    case .json:
      return JSONEncoding.default
    case .url:
      return URLEncoding.default
    }
  }
}

struct RequestURL: URLConvertible {
  let string: String
  func asURL() throws -> URL {
    return URL(string: string) ?? URL(fileURLWithPath: "")
  }
}

struct NetworkRequest: URLRequestConvertible {
  let httpMethod: HttpMethod
  let encoding: ParameterEncoding
  let path: String
  let headers: [String: String]?
  let parameters: Parameters?

  init(httpMethod: HttpMethod,
       encoding: Encoding,
       path: String,
       headers: [String: String]? = nil,
       parameters: Parameters? = nil) {

    self.httpMethod = httpMethod
    self.encoding = encoding.parameterEncoding()
    self.path = path
    self.headers = headers
    self.parameters = parameters
  }

  func asURLConvertible() -> URLConvertible {
    return RequestURL(string: path)
  }

  func asURLRequest() throws -> URLRequest {

    guard let url = URL(string: path) else {
      fatalError("Couldn't convert to url")
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.allHTTPHeaderFields = headers

    return try encoding.encode(urlRequest, with: parameters)
  }
}
