//
//  LoaderView.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import UIKit

protocol LoaderDelegate: AnyObject {
  func loaderWillAppear()
  func loaderWillDisappear()
}

class LoaderView: UIView {

  // MARK: - Constants

  private struct ViewTraits {
    static let activityIndicatorMaxSize: CGFloat = 52
    static let lineSpacing: CGFloat = 2.2
    static let fontSize: CGFloat = 14
    static let textTop: CGFloat = 25
    static let textHMargins: CGFloat = 18
  }

  // MARK: - Properties

  weak var delegate: LoaderDelegate?

  private let activityIndicatorImageView = UIImageView()
  private let textLabel = UILabel()

  var text: String? {
    get {
      textLabel.text
    }
    set {
      textLabel.font = .systemFont(ofSize: 14)
    }
  }

  // MARK: - View's Lifecycle

  init() {
    super.init(frame: .zero)
    setupComponents()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupComponents()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    if newWindow != nil {
      delegate?.loaderWillAppear()
    } else {
      delegate?.loaderWillDisappear()
    }
  }

  // MARK: - Public

  func setupActivityIndicator(on view: UIView, withPadding padding: CGFloat = 10) {
    addSubviewForAutolayout(activityIndicatorImageView)
    addSubviewForAutolayout(textLabel)

    NSLayoutConstraint.activate([
      activityIndicatorImageView.widthAnchor.constraint(equalTo: activityIndicatorImageView.heightAnchor),
      activityIndicatorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicatorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      textLabel.topAnchor.constraint(equalTo: activityIndicatorImageView.bottomAnchor, constant: ViewTraits.textTop),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.textHMargins),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.textHMargins)
    ])
  }

  func startAnimating() {
    let rotationAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
    rotationAnimation.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
    rotationAnimation.fromValue = 0
    rotationAnimation.toValue = -CGFloat(Double.pi * 2)
    rotationAnimation.isRemovedOnCompletion = false
    rotationAnimation.duration = 1
    rotationAnimation.repeatCount = .infinity
    activityIndicatorImageView.layer.add(rotationAnimation, forKey: nil)
    activityIndicatorImageView.isHidden = false
    textLabel.isHidden = false
  }

  func stopAnimating() {
    if let transform = activityIndicatorImageView.layer.presentation()?.transform {
      activityIndicatorImageView.layer.transform = transform
    }
    activityIndicatorImageView.layer.removeAllAnimations()
    activityIndicatorImageView.isHidden = true
    textLabel.isHidden = true
  }

  // MARK: - Private

  private func setupComponents() {
    activityIndicatorImageView.image = UIImage(named: "icn_loader")
    activityIndicatorImageView.isHidden = true

    if !UIAccessibility.isReduceTransparencyEnabled {
      createBlurEffect()
    } else {
      backgroundColor = .systemBackground
    }
    textLabel.numberOfLines = 0
  }

  private func createBlurEffect() {
    backgroundColor = .clear
    let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ? .dark : .light
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    addSubview(blurEffectView)
  }
}
