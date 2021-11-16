//
//  CharacterDetailPresenter.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CharacterDetailPresentationLogic {
  func presentData(response: CharacterDetail.LoadData.Response)
}

class CharacterDetailPresenter: CharacterDetailPresentationLogic {

  // MARK: - Properties

  weak var viewController: CharacterDetailDisplayLogic?
  
  // MARK: - Lifecycle
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }

  // MARK: - Public

  func presentData(response: CharacterDetail.LoadData.Response) {
    let action: GetCharacterDetailAction
    switch response.result {
    case .success(let entity):
      let viewData = CharacterDetailViewData(name: entity.name,
                                             description: entity.description,
                                             url: URL(string: entity.url))
      action = .success(viewData)
    case .failure(let error):
      let errorString: String
      switch error {
      case .responseProblem:
        errorString = "Response problems"
      case .connectionProblem:
        errorString = "Connection problems"
      }
      action = .failure(errorString)
    }
    
    viewController?.displayData(viewModel: CharacterDetail.LoadData.ViewModel(action: action))
  }

  // MARK: - Private
}
