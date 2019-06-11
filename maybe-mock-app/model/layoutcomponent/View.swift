//
//  View.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

struct DynamicLayout: Decodable {
  let component: LayoutComponent?
  
  enum CodingKeys: String, CodingKey {
    case component
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.component = (try? container.decode(Label.self, forKey: .component)).map { .label($0) }
  }
}

enum LayoutComponent: UIBuilder {
//  case container(Container)
  case label(Label)
  
  func build() -> UIView {
    switch self {
    case .label(let l):
      return l.build()
    }
  }
}

protocol UIBuilder {
  func build() -> UIView
}

extension UIView {
  func attach(layout: DynamicLayout) {
    guard let c = layout.component?.build() else { return }
    self.addSubview(c)
    self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: c.topAnchor, constant: -18).isActive = true
    self.leftAnchor.constraint(equalTo: c.leftAnchor, constant: -18).isActive = true
    self.rightAnchor.constraint(equalTo: c.rightAnchor, constant: 18).isActive = true
  }
}
