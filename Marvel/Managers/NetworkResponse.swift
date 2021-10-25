//
//  NetworkResponse.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import Foundation

struct NetworkResponse<T> {
  let headers: [String: String]
  let data: T
}
