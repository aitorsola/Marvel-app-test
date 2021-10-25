//
//  CharactersListModels.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - Use cases

enum CharactersList {
  enum DoGetCharacters {
    struct Request {
      
    }

    struct Response {
      let result: Result<[CharacterEntity], GetCharacterListError>
    }

    struct ViewModel {
      let action: GetCharactersAction
    }
  }
  
  enum DoSelectCharacter {
    struct Request {
      let index: Int
    }

    struct Response {
      
    }

    struct ViewModel {
      
    }
  }
}

// MARK: - Business models

enum GetCharactersAction {
  case success([CharacterTableViewCellData])
  case error(String)
}

// MARK: - View models

struct CharacterTableViewCellData {
  let name: String
  let description: String
  let url: URL?
}
