//
//  CharactersListPresenter.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharactersListPresentationLogic {
  func presentGetCharacters(request: CharactersList.DoGetCharacters.Response)
  func presentSelectCharacter(request: CharactersList.DoSelectCharacter.Response)
}

class CharactersListPresenter: CharactersListPresentationLogic {

  // MARK: - Properties

  weak var viewController: CharactersListDisplayLogic?
  
  // MARK: - Lifecycle
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }

  // MARK: - Public
  
  func presentGetCharacters(request: CharactersList.DoGetCharacters.Response) {
    let action: GetCharactersAction
    switch request.result {
    case .success(let entity):
      let cellData = buildTableViewCellData(data: entity)
      action = .success(cellData)
    case .failure(let error):
      let errorString: String
      switch error {
      case .responseProblem:
        errorString = "Response problems"
      case .connectionProblem:
        errorString = "Connection problems"
      }
      action = .error(errorString)
    }
    let viewModel = CharactersList.DoGetCharacters.ViewModel(action: action)
    viewController?.displayGetCharacters(request: viewModel)
  }
  
  func presentSelectCharacter(request: CharactersList.DoSelectCharacter.Response) {
    viewController?.displaySelectCharacter(request: CharactersList.DoSelectCharacter.ViewModel())
  }

  // MARK: - Private
  
  private func buildTableViewCellData(data: [CharacterEntity]) -> [CharacterTableViewCellData] {
    data.map({CharacterTableViewCellData(name: $0.name,
                                         description: $0.description,
                                         url: URL(string: $0.url ?? ""))})
  }
}
