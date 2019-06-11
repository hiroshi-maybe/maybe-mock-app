//
//  Label.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

struct Label: Decodable, UIBuilder {
  let text: String?
  let font: Font?
  
  enum CodingKeys: String, CodingKey {
    case text, font
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.text = try container.decodeIfPresent(String.self, forKey: .text)
    self.font = try container.decodeIfPresent(Font.self, forKey: .font)
  }
  
  func build() -> UIView {
    let l = UILabel().autolayoutEnabled()
    l.text = text
    l.font = font?.build()
    return l
  }
}

struct Font: Decodable {
  let size: CGFloat?
  let weight: Weight?
  let type: FontType?
  
  enum CodingKeys: String, CodingKey {
    case size, weight, type
  }
  
  enum FontType: String, Decodable {
    case normal, bold, italic
  }
  
  enum Weight: String, Decodable {
    case black, bold, heavy, light, medium, regular, semibold, thin, ultraLight
    
    var mapped: UIFont.Weight {
      let a: UIFont.Weight
      switch self {
      case .black: a = .black
      case .bold: a = .bold
      case .heavy: a = .heavy
      case .light: a = .light
      case .medium: a = .medium
      case .regular: a = .regular
      case .semibold: a = .semibold
      case .thin: a = .thin
      case .ultraLight: a = .ultraLight
      }
      return a
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.size = try container.decodeIfPresent(CGFloat.self, forKey: .size)
    self.weight = try container.decodeIfPresent(Weight.self, forKey: .weight)
    self.type = try container.decodeIfPresent(FontType.self, forKey: .type)
  }
  
  func build() -> UIFont {
    let f: UIFont
    switch (type, size, weight) {
    case let (.some(.bold), .some(s), _):
      f = UIFont.boldSystemFont(ofSize: s)
    case let (.some(.italic), .some(s), _):
      f = UIFont.italicSystemFont(ofSize: s)
    case let (_, .some(s), .some(w)):
      f = UIFont.systemFont(ofSize: s, weight: w.mapped)
    case let (_, .some(s), _):
      f = UIFont.systemFont(ofSize: s)
    default:
      f = UIFont()
    }
    return f
  }
}
