//
//  NetworkManager.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

import Alamofire

class NetworkManager: Session {

  // MARK: Public

  func request(
    _ request: NetworkRequest,
    completionHandler: @escaping (Result<NetworkResponse<Data>, NetworkError<EmptyDecodable>>) -> Void) {
      logRequest(request)
      super.request(request).responseData { dataResponse in
        self.handleResponse(dataResponse, completion: completionHandler)
      }
    }

  // MARK: - Private

  private let logResponse: DataRequest.Validation = { request, response, _ in
    let statusCode = response.statusCode
    let reqUrlStr = request?.url?.absoluteString ?? ""
    // Uncomment for debugging purposes only
    NSLog("\(reqUrlStr) --> statusCode: \(statusCode)")
    return .success(())
  }

  private func logRequest(_ request: NetworkRequest) {
    if let urlRequest = try? request.asURLRequest(),
       let urlString = urlRequest.url?.absoluteString {
      logRequest(httpMethod: request.httpMethod,
                 urlString,
                 parameters: request.parameters,
                 httpBody: urlRequest.httpBody,
                 headers: urlRequest.allHTTPHeaderFields)
    }
  }

  private func logRequest(httpMethod: HttpMethod, _ URLString: URLConvertible, parameters: [String: Any]?,
                          httpBody: Data? = nil, headers: [String: String]?) {
    var logs = ["\(httpMethod) \(URLString)"]

    if let headers = headers, !headers.isEmpty {
      if let jsonData = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted),
         let jsonStr = String(data: jsonData, encoding: .utf8) {
        logs += ["headers:"]
        logs += jsonStr.components(separatedBy: "\n")
      }
    }

    if let parameters = parameters, !parameters.isEmpty {
      if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
         let jsonStr = String(data: jsonData, encoding: .utf8) {
        logs += ["params:"]
        logs += jsonStr.components(separatedBy: "\n")
      }
    }

    if let body = httpBody {
      if let jsonStr = String(data: body, encoding: .utf8) {
        logs += ["body:"]
        logs += jsonStr.components(separatedBy: "\n")
      }
    }
    print("🌍 Request: \(logs))")
  }

  private func handleResponse<ErrorType: Decodable>(
    _ response: AFDataResponse<Data>,
    completion: @escaping (Swift.Result<NetworkResponse<Data>, NetworkError<ErrorType>>) -> Void) {
      let headers = adaptHeaders(response.response?.allHeaderFields ?? [:])
      let data = response.data ?? Data()
      switch response.result {
      case .success:
        let networkResponse = NetworkResponse(headers: headers, data: data)
        completion(.success(networkResponse))
      case .failure:
        let errorCode = response.response?.statusCode
        if errorCode == NSURLErrorNotConnectedToInternet {
          let networkError = NetworkError<ErrorType>(code: NetworkErrorCode.noConnection, response: nil)
          completion(.failure(networkError))
        } else if let errorModel = EntityParser().parse(data: data, entityType: ErrorType.self) {
          let networkResponse = NetworkResponse(headers: headers, data: errorModel)
          let networkError = NetworkError(code: NetworkErrorCode.from(code: errorCode), response: networkResponse)
          completion(.failure(networkError))
        } else {
          let networkError = NetworkError<ErrorType>(code: NetworkErrorCode.unableToParseResponse, response: nil)
          completion(.failure(networkError))
        }
      }
    }

  private func adaptHeaders(_ headers: [AnyHashable: Any]) -> [String: String] {
    var adaptedHeaders: [String: String] = [:]
    for (key, value) in headers {
      guard let keyString = key as? String, let valueString = value as? String else {
        continue
      }
      adaptedHeaders[keyString] = valueString
    }
    return adaptedHeaders
  }
}
