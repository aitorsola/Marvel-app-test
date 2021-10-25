//
//  UIViewController.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import UIKit

private enum UIViewControllerConstants {
  static let loaderViewTag = 7658
  static let loaderTransitionDuration: TimeInterval = 0.3
}

extension UIViewController {
  
  func showLoader(centeredOn view: UIView? = nil,
                  withDelegate delegate: LoaderDelegate? = nil,
                  overCenteredView: Bool = false,
                  overFullScreen: Bool = false,
                  text: String? = nil) {

    view?.subviews.forEach({ aView in
      if aView.isKind(of: LoaderView.self) {
        aView.removeFromSuperview()
      }
    })

    let loaderView = LoaderView()
    loaderView.tag = UIViewControllerConstants.loaderViewTag
    loaderView.alpha = 0
    loaderView.delegate = delegate
    loaderView.text = text

    let destinationView: UIView
    let keyWindow = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .map({ $0 as? UIWindowScene })
      .compactMap({ $0 })
      .first?.windows
      .first(where: { $0.isKeyWindow })
    if overFullScreen, let window = keyWindow {
      destinationView = window
    } else {
      destinationView = self.view
    }
    destinationView.addSubviewForAutolayout(loaderView)

    let activityIndicatorAnchorView = view ?? destinationView
    loaderView.setupActivityIndicator(on: activityIndicatorAnchorView)

    let constraintView: UIView
    if overCenteredView, let centeredView = view {
      constraintView = centeredView
    } else {
      constraintView = destinationView
    }

    NSLayoutConstraint.activate([
      loaderView.leadingAnchor.constraint(equalTo: constraintView.leadingAnchor),
      loaderView.trailingAnchor.constraint(equalTo: constraintView.trailingAnchor),
      loaderView.topAnchor.constraint(equalTo: constraintView.topAnchor),
      loaderView.bottomAnchor.constraint(equalTo: constraintView.bottomAnchor)
    ])

    loaderView.startAnimating()
    loaderView.alpha = 1
  }

  func hideLoader(_ completion: (() -> Void)? = nil) {
    let keyWindow = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .map({ $0 as? UIWindowScene })
      .compactMap({ $0 })
      .first?.windows
      .first(where: { $0.isKeyWindow })

    let loaders: [UIView]
    let loadersInSubView = view.subviews.compactMap({ $0.viewWithTag(UIViewControllerConstants.loaderViewTag) })
    if loadersInSubView.isEmpty {
      loaders = keyWindow?.subviews.compactMap { $0.viewWithTag(UIViewControllerConstants.loaderViewTag) } ?? []
    } else {
      loaders = loadersInSubView
    }

    loaders.forEach { view in
      UIView.animate(withDuration: UIViewControllerConstants.loaderTransitionDuration, animations: {
        view.alpha = 0
      }, completion: { _ in
        view.removeFromSuperview()
        completion?()
      })
    }
  }
}
