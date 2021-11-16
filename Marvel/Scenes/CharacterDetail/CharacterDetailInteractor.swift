//
//  CharacterDetailInteractor.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterDetailBusinessLogic {
  func doLoadData(request: CharacterDetail.LoadData.Request)
}

protocol CharacterDetailDataStore {
  var characterSelected: CharacterEntity? { get set }
}

class CharacterDetailInteractor: CharacterDetailBusinessLogic, CharacterDetailDataStore {

  // MARK: - Properties

  var presenter: CharacterDetailPresentationLogic?
  
  var charactersApi: CharacterDetailAPI?
  
  var characterSelected: CharacterEntity?
  var characterResponse: CharacterEntity?
  
  // MARK: - Lifecycle
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }
  
  // MARK: - Public

  func doLoadData(request: CharacterDetail.LoadData.Request) {
    guard let characterId = characterSelected?.id else {
      return
    }
    let parameters = GetCharacterDetailParameters(id: characterId)
    charactersApi?.getCharacterDetail(parameters: parameters, completion: { [weak self] result in
      if case .success(let characterEntity) = result {
        self?.characterResponse = characterEntity
      }
      let response = CharacterDetail.LoadData.Response(result: result)
      self?.presenter?.presentData(response: response)
    })
  }

  // MARK: - Private
}
