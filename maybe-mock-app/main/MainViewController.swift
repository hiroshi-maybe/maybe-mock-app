//
//  MainViewController.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/6/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  fileprivate var dataSource: LayoutDataSource? {
    didSet {
      self.tableView.dataSource = dataSource
    }
  }
  
  fileprivate var model: HomeLayoutModel? {
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
    t.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
    t.register(TwoLinersTableViewCell.self, forCellReuseIdentifier: TwoLinersTableViewCell.identifier)
    t.delegate = self
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
  }
}

extension MainViewController {
  fileprivate func fetch(completed: @escaping () -> Void = {}) {
    makeRequest(path: "/layout", method: .get) { [weak self] (res: NetworkResponse<HomeLayout>) in
      defer { completed() }
      switch res {
      case .failure(let err):
        self?.showAlert(of: err)
      case .success(let layout):
        let c = self?.model?.counter ?? 0
        self?.model = layout.flatMap { HomeLayoutModel(counter: c + 1, layout: $0) }
      }
    }
  }
  
  @objc fileprivate func handleRefreshControl() {
    fetch() { [weak self] in
      DispatchQueue.main.async {
        self?.refreshControl.endRefreshing()
      }
    }
  }
}
