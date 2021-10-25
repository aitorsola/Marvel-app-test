//
//  CharacterDetailModels.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum CharacterDetail {
  enum LoadData {
    struct Request {
      
    }

    struct Response {
      let result: Result<CharacterEntity, GetCharacterDetailError>
    }

    struct ViewModel {
      let action: GetCharacterDetailAction
    }
  }
}

// MARK: - Business models

enum GetCharacterDetailAction {
  case success(CharacterDetailViewData)
  case failure(String)
}

// MARK: - View models

struct CharacterDetailViewData {
  let name: String
  let description: String
  let url: URL?
}
