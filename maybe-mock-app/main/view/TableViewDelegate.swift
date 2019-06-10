//
//  DataSource.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/10/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

class LayoutDataSource: NSObject, UITableViewDataSource {
  let rows: [HomeLayoutModel.Row]
  
  init(rows: [HomeLayoutModel.Row]) {
    self.rows = rows
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let c = tableView.dequeueReusableCell(withIdentifier: self.rows[indexPath.row].cellIdentifier, for: indexPath)
    switch (self.rows[indexPath.row], c) {
    case (let .oneLiner(title: title), let c as BasicTableViewCell):
      c.configure(title: title)
    case (let .twoLiners(title: title, subtitle: subtitle), let c as TwoLinersTableViewCell):
      c.configure(title: title, subtitle: subtitle)
    default: fatalError("Unexpected cell is returned")
    }
    
    c.selectionStyle = .none
    return c
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showLayoutCanvas", sender: self)
  }
}
