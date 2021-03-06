//
//  NetworkManager+CharacterList.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

protocol CharacterDetailAPI: AnyObject {
  func getCharacterDetail(parameters: GetCharacterDetailParameters,
                          completion: @escaping (Result<CharacterEntity, GetCharacterDetailError>) -> Void)
}

private enum CharacterDetailAPIEndpoint {
  static let characterDetail = "/v1/public/characters/@id"
}

extension NetworkManager: CharacterDetailAPI {
  
  func getCharacterDetail(parameters: GetCharacterDetailParameters,
                          completion: @escaping (Result<CharacterEntity, GetCharacterDetailError>) -> Void) {
    let apiKey = Obfuscator.default.stringFromBytes(encryptedByteArray: NetworkConstants.pubKey) ?? ""
    let requestData = GetCharacterListRequest(ts: NetworkConstants.timestamp,
                                              apiKey: apiKey,
                                              hash: NetworkConstants.hash)
    var urlComponents = URLComponents(string: NetworkConstants.baseURL)
    urlComponents?.path = CharacterDetailAPIEndpoint.characterDetail.replacingOccurrences(of: "@",
                                                                                          with: "\(parameters.id)")
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
        if let entity = Helpers.parser.parse(data: data.data, entityType: CharacterDetailResponse.self, headers: [:]) {
          if let firstEntity = entity.first {
            completion(.success(firstEntity))
          } else {
            completion(.failure(.responseProblem))
          }
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

struct CharacterDetailResponse: Decodable, DomainConvertible {
  typealias DomainEntityType = [CharacterEntity]
  
  let data: CharacterDetailResultData
  
  func domainEntity(headers: [String : String]) -> [CharacterEntity]? {
    return data.results.map { item in
      let url: String?
      if let path = item.thumbnail?.path, let `extension` = item.thumbnail?.extension {
        url = path + "." + `extension`
      } else {
        url = nil
      }
      return CharacterEntity(id: Int(item.id) ?? 0, name: item.name, description: item.description, url: url)
    }
  }
  
  struct CharacterDetailResultData: Decodable {
    let results: [CharacterDetailResult]
  }
  
  struct CharacterDetailResult: Decodable {
    let id: String
    let name: String
    let description: String
    let thumbnail: CharacterURL?
  }
  
  struct CharacterURL: Decodable {
    let path: String
    let `extension`: String
  }
}

struct GetCharacterDetailRequest {
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

enum GetCharacterDetailError: Error {
  case connectionProblem
  case responseProblem
}

struct GetCharacterDetailParameters {
  let id: Int
}
