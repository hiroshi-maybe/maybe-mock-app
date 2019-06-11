//
//  Layout.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

struct HomeLayoutModel {
  let counter: Int
  let title: String
  let rows: [Row]
  
  enum Row {
    case oneLiner(title: String)
    case twoLiners(title: String, subtitle: String)
    
    var cellIdentifier: String {
      switch self {
      case .oneLiner: return BasicTableViewCell.identifier
      case .twoLiners: return TwoLinersTableViewCell.identifier
      }
    }
  }
  
  init(counter: Int, layout: HomeLayout) {
    self.counter = counter
    self.title = layout.title
    self.rows = layout.rows.map { r in
      r.subtitle.map { s in Row.twoLiners(title: r.title, subtitle: s) } ?? Row.oneLiner(title: r.title)
    }
  }
}
