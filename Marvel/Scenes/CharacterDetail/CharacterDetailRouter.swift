//
//  CharacterDetailRouter.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterDetailRoutingLogic {
  func routeBack()
}

protocol CharacterDetailDataPassing {
  var dataStore: CharacterDetailDataStore? { get }
}

class CharacterDetailRouter: CharacterDetailRoutingLogic, CharacterDetailDataPassing {

  // MARK: - Properties

  weak var viewController: CharacterDetailViewController?
  var dataStore: CharacterDetailDataStore?

  // MARK: - Routing

  func routeBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }
}
