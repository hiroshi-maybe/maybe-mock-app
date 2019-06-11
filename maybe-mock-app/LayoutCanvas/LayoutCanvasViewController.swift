//
//  LayoutCanvasViewController.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

class LayoutCanvasViewController: UIViewController {
  
  var model: DynamicLayout? {
    didSet {
      model.map{ self.view.attach(layout: $0) }
    }
  }
  
  lazy var indicator: UIActivityIndicatorView = {
    let a = UIActivityIndicatorView().autolayoutEnabled()
    a.hidesWhenStopped = true
    a.color = UIColor.black
    return a
  }()
  
  private func setupViews() {
    self.view.addSubview(indicator)
    self.view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
    self.view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: indicator.centerYAnchor).isActive = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Layout Canvas"
    setupViews()
    fetch()
  }
  
  fileprivate func fetch(completed: @escaping () -> Void = {}) {
    indicator.startAnimating()
    makeRequest(path: "/dynamiclayout", method: .get) { [weak self] (res: NetworkResponse<DynamicLayout>) in
      self?.indicator.stopAnimating()
      defer { completed() }
      switch res {
      case .failure(let err):
        self?.showAlert(of: err)
      case .success(let layout):
        self?.model = layout
      }
    }
  }
}
