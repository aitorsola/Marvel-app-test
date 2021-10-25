//
//  NetworkErrors.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

enum NetworkErrorCode: Int {
  case noConnection = -4
  case unableToParseResponse = -3
  case unableToCreateUrl = -2
  case generic = -1
  case notModified = 304
  case badRequest = 400
  case unauthorized = 401
  case emailUsedWithAnotherAccount = 484
  case userAlreadyExists = 402
  case forbidden = 403
  case notFound = 404
  case invalidOldPassword = 405
  case cantChangeRRSSPassword = 406
  case requestTimeout = 408
  case conflict = 409
  case gone = 410
  case preconditionFailed = 412
  case needsUsername = 418
  case unprocessableEntity = 422
  case upgradeRequired = 426
  case tooManyRequests = 429
  case unavailableForLegalReasons = 451
  case internalServerError = 500
  case badGateway = 502
  case serviceUnavailable = 503

  static func from(code: Int?) -> NetworkErrorCode {
    if let code = code, let error = NetworkErrorCode(rawValue: code) {
      return error
    }
    return .generic
  }

  static func from(error: Error) -> NetworkErrorCode {
    NetworkErrorCode(rawValue: (error as NSError).code) ?? .generic
  }
}

struct NetworkError<T: Decodable>: Error {
  let code: NetworkErrorCode
  let response: NetworkResponse<T>?
}

struct EmptyDecodable: Decodable {
}
