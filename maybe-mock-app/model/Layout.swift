//
//  Layout.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/6/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

struct Row: Codable {
  
  enum CodingKeys: String, CodingKey {
    case title
    case subtitle
  }
  
  let title: String
  let subtitle: String
}

struct Layout: Codable {
  enum CodingKeys: String, CodingKey {
    case title
    case rows
  }
  
  let title: String
  let rows: [Row]
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.title = try container.decode(String.self, forKey: .title)
    self.rows = try container.decode([Row].self, forKey: .rows)
  }
}
