//
//  CharactersListRouter.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharactersListRoutingLogic {
  func routeBack()
  func routeCharacterDetail()
}

protocol CharactersListDataPassing {
  var dataStore: CharactersListDataStore? { get }
}

class CharactersListRouter: CharactersListRoutingLogic, CharactersListDataPassing {

  // MARK: - Properties

  weak var viewController: CharactersListViewController?
  var dataStore: CharactersListDataStore?
  
  // MARK: - Lifecycle
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
  
  func routeCharacterDetail() {
    let destVC = CharacterDetailViewController.build()
    guard let characterDetailVC = destVC as? CharacterDetailViewController else {
      return
    }
    if var destinationDS = characterDetailVC.router?.dataStore, let characterSelected = dataStore?.selectedCharacter {
      destinationDS.characterSelected = characterSelected
    }
    viewController?.navigationController?.pushViewController(characterDetailVC, animated: true)
  }
}
