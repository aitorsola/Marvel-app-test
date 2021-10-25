//
//  UIViewController.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import UIKit

extension UIView {
  
  func addSubviewForAutolayout(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)
  }
}
