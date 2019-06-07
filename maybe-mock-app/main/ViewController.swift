//
//  ViewController.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/6/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  fileprivate var dataSource: LayoutDataSource? {
    didSet {
      self.tableView.dataSource = dataSource
    }
  }
  
  fileprivate var model: LayoutModel? {
    didSet {
      guard let m = model else { return }
      self.navigationItem.title = m.title + " (" + String(m.counter) + ")"
      self.dataSource = LayoutDataSource(rows: m.rows)
    }
  }
  
  fileprivate lazy var refreshControl: UIRefreshControl = {
    let r = UIRefreshControl()
    r.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    return r
  }()
  
  private lazy var tableView: UITableView = {
    let t = UITableView()
//    t.register(UITableViewCell.self, forCellReuseIdentifier: "detailedcell")
    t.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
    t.register(TwoLinersTableViewCell.self, forCellReuseIdentifier: TwoLinersTableViewCell.identifier)
    t.translatesAutoresizingMaskIntoConstraints = false
    t.refreshControl = self.refreshControl
    t.estimatedRowHeight = 52
    t.rowHeight = UITableView.automaticDimension
    t.tableFooterView = UIView(frame: .zero)
    view.addSubview(t)
    return t
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetch() { [weak self] in self?.tableView.reloadData() }
  }
  
  private func setupViews() {
    self.navigationItem.title = "Welcome"
    self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
    self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    self.view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive = true
    self.view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
  }
}

extension ViewController {
  fileprivate func fetch(completed: @escaping () -> Void = {}) {
    makeRequest(path: "/layout", method: .get) { [weak self] (res: NetworkResponse<Layout>) in
      defer { completed() }
      switch res {
      case .failure(let err):
        self?.showAlert(of: err)
      case .success(let layout):
        let c = self?.model?.counter ?? 0
        self?.model = layout.flatMap { LayoutModel(counter: c + 1, layout: $0) }
      }
    }
  }
  
  fileprivate func showAlert(of err: Error) {
    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc fileprivate func handleRefreshControl() {
    fetch() { [weak self] in
      DispatchQueue.main.async {
        self?.refreshControl.endRefreshing()
      }
    }
  }
}

struct LayoutModel {
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
  
  init(counter: Int, layout: Layout) {
    self.counter = counter
    self.title = layout.title
    self.rows = layout.rows.map { r in
      r.subtitle.map { s in Row.twoLiners(title: r.title, subtitle: s) } ?? Row.oneLiner(title: r.title)
    }
  }
}

class LayoutDataSource: NSObject, UITableViewDataSource {
  let rows: [LayoutModel.Row]
  
  init(rows: [LayoutModel.Row]) {
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
    return c
  }
}
