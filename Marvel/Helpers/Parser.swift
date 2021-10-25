//
//  Parser.swift.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

struct EntityParser {

  func parse<MyDecodable: Decodable>(data: Data, entityType: MyDecodable.Type) -> MyDecodable? {
    let decoder = JSONDecoder()
    var returnValue: MyDecodable?
    do {
      let data = (data.isEmpty) ? try JSONSerialization.data(withJSONObject: [:]) : data
      returnValue = try decoder.decode(entityType, from: data)
    } catch {
      if let derror = error as? DecodingError {
        print(error.localizedDescription)
        print(derror)
      }
    }
    return returnValue
  }

  func parse<MyDecodable: Decodable & DomainConvertible>(data: Data,
                                                         entityType: MyDecodable.Type,
                                                         headers: [String: String]) -> MyDecodable.DomainEntityType? {
    let entity = parse(data: data, entityType: entityType)
    return entity?.domainEntity(headers: headers)
  }

  func parse<MyDecodable: Decodable & DomainConvertible>(data: Data,
                                                         entityType: [MyDecodable].Type,
                                                         headers: [String: String]) -> [MyDecodable.DomainEntityType]? {
    let entities = parse(data: data, entityType: entityType)
    return entities?.compactMap { $0.domainEntity(headers: headers) }
  }
}
