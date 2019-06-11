//
//  Label.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

struct Label: Codable, UIBuilder {
  let text: String?
  
  enum CodingKeys: String, CodingKey {
    case text
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.text = try container.decode(String.self, forKey: .text)
  }
  
  func build() -> UIView {
    let l = UILabel().autolayoutEnabled()
    l.text = text
    return l
  }
}
