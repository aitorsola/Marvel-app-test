//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CharacterDetailDisplayLogic: AnyObject {
  func displayData(viewModel: CharacterDetail.LoadData.ViewModel)
}

class CharacterDetailViewController: UIViewController {
  
  // MARK: - Build
  
  static func build() -> UIViewController {
    UIStoryboard(name: "CharacterDetail", bundle: nil).instantiateInitialViewController() ?? UIViewController()
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var characterImageView: UIImageView!
  @IBOutlet weak var characterNameLabel: UILabel!
  @IBOutlet weak var characterDescriptionLabel: UILabel!
  
  var interactor: CharacterDetailBusinessLogic?
  var router: (CharacterDetailRoutingLogic & CharacterDetailDataPassing)?
  
  // MARK: - Object's lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    let viewController = self
    let interactor = CharacterDetailInteractor()
    let presenter = CharacterDetailPresenter()
    let router = CharacterDetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.charactersApi = Managers.network
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: - View's lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupComponents()
    doLoadData()
  }
  
  // MARK: - Private
  
  private func setupUI(data: CharacterDetailViewData) {
    title = "Character detail"
    characterImageView.sd_setImage(with: data.url)
    characterNameLabel.text = data.name
    characterDescriptionLabel.text = data.description
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupComponents() {
    characterImageView.contentMode = .scaleAspectFill
    characterImageView.clipsToBounds = true
    characterImageView?.layer.masksToBounds = true
    characterImageView?.layer.cornerRadius = 10
  }
}

// MARK: - Output

extension CharacterDetailViewController {
  
  private func doLoadData() {
    showLoader()
    let request = CharacterDetail.LoadData.Request()
    interactor?.doLoadData(request: request)
  }
}

// MARK: - Input

extension CharacterDetailViewController: CharacterDetailDisplayLogic {
  
  func displayData(viewModel: CharacterDetail.LoadData.ViewModel) {
    hideLoader()
    switch viewModel.action {
    case .success(let viewData):
      setupUI(data: viewData)
    case .failure(let error):
      Helpers.banner.showBanner(options: NotificationBannerOptions(title: error,
                                                                   delegate: nil,
                                                                   style: .warning))
    }
    
  }
}
