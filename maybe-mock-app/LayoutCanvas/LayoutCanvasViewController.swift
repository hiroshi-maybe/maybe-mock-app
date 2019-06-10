//
//  LayoutCanvasViewController.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

class LayoutCanvasViewController: UIViewController {
  lazy var messageLabel: UILabel = {
    let l = UILabel().enableAutolayout()
    l.text = "Welcome"
    return l
  }()
  
  private func setupViews() {
    self.view.addSubview(messageLabel)
    self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -18).isActive = true
    self.view.leftAnchor.constraint(equalTo: messageLabel.leftAnchor, constant: -18).isActive = true
    self.view.rightAnchor.constraint(equalTo: messageLabel.rightAnchor, constant: 18).isActive = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Layout Canvas"
    setupViews()
  }
}
