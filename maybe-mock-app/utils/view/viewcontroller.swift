//
//  viewcontroller.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(of err: Error) {
    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
}
