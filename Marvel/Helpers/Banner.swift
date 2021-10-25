//
//  Banner.swift
//  Marvel
//
//  Created by Aitor Sola on 25/10/21.
//

import NotificationBannerSwift

struct NotificationBannerOptions {
  let title: String
  let subtitle: String? = nil
  let rightView: UIView? = nil
  weak var delegate: NotificationBannerDelegate?
  let onTap: (() -> Void)? = nil
  let style: BannerStyle
}

class NotificationBanner {

  func showBanner(options: NotificationBannerOptions) {

    let banner = NotificationBannerSwift.NotificationBanner(title: options.title,
                                                            subtitle: options.subtitle,
                                                            rightView: options.rightView,
                                                            style: options.style)

    banner.onTap = options.onTap
    banner.haptic = .light
    banner.delegate = options.delegate
    banner.titleLabel?.text = options.title
    banner.show()
  }
}
