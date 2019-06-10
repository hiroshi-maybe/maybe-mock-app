//
//  label.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

extension UILabel {
  @discardableResult func enableAutolayout() -> UILabel {
    self.translatesAutoresizingMaskIntoConstraints = false
    return self
  }
}
