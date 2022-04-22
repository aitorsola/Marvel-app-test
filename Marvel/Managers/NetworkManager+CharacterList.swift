//
//  NetworkManager+CharacterList.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

protocol CharacterListAPI: AnyObject {
  func getCharacterList(parameters: GetCharacterListParameters,
                        completion: @escaping (Result<[CharacterEntity], GetCharacterListError>) -> Void)
}

private enum CharacterListAPIEndpoint {
  static let characterList = "/v1/public/characters"
}

extension NetworkManager: CharacterListAPI {
  
  func getCharacterList(parameters: GetCharacterListParameters,
                        completion: @escaping (Result<[CharacterEntity], GetCharacterListError>) -> Void) {
    let apiKey = Obfuscator.default.stringFromBytes(encryptedByteArray: NetworkConstants.pubKey) ?? ""
    let requestData = GetCharacterListRequest(ts: NetworkConstants.timestamp,
                                              apiKey: apiKey,
                                              hash: NetworkConstants.hash)
    var urlComponents = URLComponents(string: NetworkConstants.baseURL)
    urlComponents?.path = CharacterListAPIEndpoint.characterList
    urlComponents?.queryItems = requestData.getQueryItems().map({ key, value in
      URLQueryItem(name: key, value: value)
    })
    let path = urlComponents?.url?.absoluteString ?? ""
    let networkRequest = NetworkRequest(httpMethod: .get,
                                        encoding: .json,
                                        path: path,
                                        headers: nil,
                                        parameters: nil)
    
    request(networkRequest) { result in
      switch result {
      case .success(let data):
        if let entity = Helpers.parser.parse(data: data.data, entityType: CharacterListResponse.self, headers: [:]) {
          completion(.success(entity))
        } else {
          completion(.failure(.responseProblem))
        }
      case .failure(let error):
        switch error.code {
        case .noConnection:
          completion(.failure(.connectionProblem))
        default:
          completion(.failure(.responseProblem))
        }
      }
    }
  }
}

// Request Models

struct CharacterListResponse: Decodable, DomainConvertible {
  typealias DomainEntityType = [CharacterEntity]
  
  let data: CharacterListResultData
  
  func domainEntity(headers: [String : String]) -> [CharacterEntity]? {
    return data.results.map { item in
      let url: String?
      if let path = item.thumbnail?.path, let `extension` = item.thumbnail?.extension {
        url = path + "." + `extension`
      } else {
        url = nil
      }
      return CharacterEntity(id: item.id, name: item.name, description: item.description, url: url)
    }
  }
  
  struct CharacterListResultData: Decodable {
    let results: [CharacterListResult]
  }
  
  struct CharacterListResult: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: CharacterURL?
  }
  
  struct CharacterURL: Decodable {
    let path: String
    let `extension`: String
  }
}

struct GetCharacterListRequest {
  let ts: String
  let apiKey: String
  let hash: String
  
  func getQueryItems() -> [String: String] {
    [
      "ts": ts,
      "apikey": apiKey,
      "hash": hash
    ]
  }
}

enum GetCharacterListError: Error {
  case connectionProblem
  case responseProblem
}

struct GetCharacterListParameters {
  
}
