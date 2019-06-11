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
    self.component = try? container.decode(LayoutComponent.self, forKey: .component)
  }
}

struct LayoutComponent: Decodable, UIBuilder {
  let view: ViewComponent
  
  enum CodingKeys: String, CodingKey {
    case view
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.view = try container.decode(ViewComponent.self, forKey: .view)
  }
  
  func build() -> UIView {
    return view.build()
  }
}

enum ViewComponent: Decodable, UIBuilder {
  case stack(Stack)
  case label(Label)
  
  enum CodingKeys: String, CodingKey {
    case type
  }
  
  enum ViewType: String, Decodable {
    case stack, label
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let t = try container.decode(ViewType.self, forKey: .type)
    switch t {
    case .label:
      self = .label(try Label(from: decoder))
    case .stack:
      self = .stack(try Stack(from: decoder))
    }
  }
  
  func build() -> UIView {
    switch self {
    case .label(let l):
      return l.build()
    case .stack(let s):
      return s.build()
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
