//
//  DomainConvertible.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

protocol DomainConvertible {
  associatedtype DomainEntityType
  func domainEntity(headers: [String: String]) -> DomainEntityType?
}
