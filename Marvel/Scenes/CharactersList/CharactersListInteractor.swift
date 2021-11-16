//
//  CharactersListInteractor.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharactersListBusinessLogic {
  func doGetCharacters(request: CharactersList.DoGetCharacters.Request)
  func doSelectCharacter(request: CharactersList.DoSelectCharacter.Request)
}

protocol CharactersListDataStore {
  var selectedCharacter: CharacterEntity? { get set }
}

class CharactersListInteractor: CharactersListBusinessLogic, CharactersListDataStore {

  // MARK: - Properties

  var presenter: CharactersListPresentationLogic?
  var charactersApi: CharacterListAPI?
  
  private var characters: [CharacterEntity] = []
  var selectedCharacter: CharacterEntity?
  
  // MARK: - Lifecycle
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }

  // MARK: - Public
  
  func doGetCharacters(request: CharactersList.DoGetCharacters.Request) {
    charactersApi?.getCharacterList(parameters: GetCharacterListParameters(), completion: { [weak self] result in
      if case .success(let characters) = result {
        self?.characters = characters
      }
      let response = CharactersList.DoGetCharacters.Response(result: result)
      self?.presenter?.presentGetCharacters(request: response)
    })
  }
  
  func doSelectCharacter(request: CharactersList.DoSelectCharacter.Request) {
    self.selectedCharacter = characters[request.index]
    presenter?.presentSelectCharacter(request: CharactersList.DoSelectCharacter.Response())
  }

  // MARK: - Private
}
