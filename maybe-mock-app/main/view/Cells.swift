//
//  Cells.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/6/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

private let titleFont = UIFont.systemFont(ofSize: 24.0)
private let subtitleFont = UIFont.systemFont(ofSize: 18.0)

extension UILabel {
  fileprivate func configureTitleStyle() -> UILabel {
    self.enableAutolayout()
    self.font = titleFont
    self.textColor = UIColor.black
    return self
  }
  fileprivate func configureSubtitleStyle() ->UILabel {
    self.enableAutolayout()
    self.font = subtitleFont
    self.textColor = UIColor.gray
    return self
  }
}

class BasicTableViewCell: UITableViewCell {
  static let identifier = "basiccell"
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel().configureTitleStyle()
    return titleLabel
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 18).isActive = true
    self.contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 18).isActive = true
    self.contentView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 18).isActive = true
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(title: String) {
    titleLabel.text = title
  }
}

class TwoLinersTableViewCell: UITableViewCell {
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel().configureTitleStyle()
    return titleLabel
  }()
  
  private lazy var subtitleLabel: UILabel = {
    let titleLabel = UILabel().configureSubtitleStyle()
    return titleLabel
  }()
  
  static let identifier = "twolinercell"
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fill
    stack.spacing = 5.0
    stack.addArrangedSubview(titleLabel)
    stack.addArrangedSubview(subtitleLabel)
    
    self.contentView.addSubview(stack)
    stack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 18).isActive = true
    self.contentView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 18).isActive = true
    stack.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 18).isActive = true
    self.contentView.rightAnchor.constraint(equalTo: stack.rightAnchor, constant: 18).isActive = true
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(title: String, subtitle: String) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
  }
}
