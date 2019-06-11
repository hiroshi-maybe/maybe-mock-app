//
//  Stack.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/11/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

struct Stack: Decodable, UIBuilder {
  let axis: Axis
  let spacing: CGFloat
  let components: [LayoutComponent]
  
  enum CodingKeys: String, CodingKey {
    case axis, spacing, components
  }
  
  enum Axis: String, Codable {
    case horizontal
    case vertical
    
    var mapped: NSLayoutConstraint.Axis {
      switch self {
      case .horizontal:
        return .horizontal
      case .vertical:
        return .vertical
      }
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.axis = try container.decode(Stack.Axis.self, forKey: .axis)
    self.spacing = try container.decode(CGFloat.self, forKey: .spacing)
    self.components = try container.decode([LayoutComponent].self, forKey: .components)
  }
  
  func build() -> UIView {
    let v = UIStackView().autolayoutEnabled()
    v.axis = self.axis.mapped
    v.spacing = self.spacing
    for c in components {
      v.addArrangedSubview(c.build())
    }
    return v
  }
}
