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
  
  struct Row {
    let segue: String?
    let view: View
  }
  
  enum View {
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
      let v = r.subtitle.map { s in HomeLayoutModel.View.twoLiners(title: r.title, subtitle: s) } ?? HomeLayoutModel.View.oneLiner(title: r.title)
      return HomeLayoutModel.Row(segue: r.segueId, view: v)
    }
  }
}
