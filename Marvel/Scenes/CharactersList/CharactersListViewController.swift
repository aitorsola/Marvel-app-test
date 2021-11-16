//
//  CharactersListViewController.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol CharactersListDisplayLogic: AnyObject {
  func displayGetCharacters(request: CharactersList.DoGetCharacters.ViewModel)
  func displaySelectCharacter(request: CharactersList.DoSelectCharacter.ViewModel)
}

class CharactersListViewController: UIViewController {
  
  // MARK: - Build
  
  static func build() -> UIViewController {
    UIStoryboard(name: "CharacterList", bundle: nil).instantiateInitialViewController() ?? UIViewController()
  }
  
  // MARK: - Properties

  var interactor: CharactersListBusinessLogic?
  var router: (CharactersListRoutingLogic & CharactersListDataPassing)?
  
  private(set) var tableViewDataSource: [CharacterTableViewCellData] = [] {
    didSet {
      tableView?.reloadData()
    }
  }
  
  // MARK: - Outlets
  
  @IBOutlet weak var tableView: UITableView?

  // MARK: - Object's lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
    setupComponents()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  deinit {
    print("👋🏻👋🏻👋🏻👋🏻 \(self)")
  }

  // MARK: - Setup

  private func setup() {
    let viewController = self
    let interactor = CharactersListInteractor()
    let presenter = CharactersListPresenter()
    let router = CharactersListRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.charactersApi = Managers.network
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  private func setupComponents() {
    tableView?.backgroundColor = .clear
    tableView?.separatorStyle = .none
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.estimatedRowHeight = UITableView.automaticDimension
    tableView?.register(UINib(nibName: "CharacterTableViewCell", bundle: nil),
                        forCellReuseIdentifier: "CharacterTableViewCell")
  }

  // MARK: - View's lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupComponents()
    doGetCharacters()
  }

  // MARK: - Private
  
  private func doGetCharacters() {
    showLoader()
    interactor?.doGetCharacters(request: CharactersList.DoGetCharacters.Request())
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Character List" // this should be localized
  }
}

// MARK: - Output

extension CharactersListViewController {

}

// MARK: - Input

extension CharactersListViewController: CharactersListDisplayLogic {
  
  func displayGetCharacters(request: CharactersList.DoGetCharacters.ViewModel) {
    hideLoader()
    switch request.action {
    case .success(let cellData):
      tableViewDataSource = cellData
    case .error(let errorString):
      Helpers.banner.showBanner(options: NotificationBannerOptions(title: errorString,
                                                                   delegate: nil,
                                                                   style: .danger))
    }
  }
  
  func displaySelectCharacter(request: CharactersList.DoSelectCharacter.ViewModel) {
    router?.routeCharacterDetail()
  }
}

// MARK: - UITableViewDelegate&Datasource

extension CharactersListViewController: UITableViewDelegate&UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableViewDataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell",
                                             for: indexPath)
    guard let characterCell = cell as? CharacterTableViewCell else {
      return cell
    }
    characterCell.setupUI(data: tableViewDataSource[indexPath.row])
    return characterCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let request = CharactersList.DoSelectCharacter.Request(index: indexPath.row)
    interactor?.doSelectCharacter(request: request)
  }
}
