//
//  CalculatorViewController.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/24/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import UIKit

private let buttonLabelSize = 40
private let buttonFont = UIFont.systemFont(ofSize: CGFloat(buttonLabelSize), weight: .thin)

func makeButton(text: String) -> UIButton {
  let v = UIButton()
  v.titleLabel?.font = buttonFont
  v.setTitle(text, for: .normal)
  v.setTitleColor(UIColor.gray, for: .normal)
  return v
}

func makeRowStack() -> UIStackView {
  let hstack = UIStackView()
  hstack.axis = .horizontal
  hstack.spacing = 5.0
  hstack.alignment = .center
  hstack.distribution = .fillEqually
  return hstack
}

class CalculatorViewController: UIViewController {
  
  private var model = {
    return CalcModel()
  }()
  
  lazy var vstack: UIStackView = {
    let v = UIStackView().autolayoutEnabled()
    v.axis = .vertical
    v.spacing = 2.0
    
    v.addArrangedSubview(self.subLabel)
    v.addArrangedSubview(self.mainLabel)
    
    return v
  }()
  
  func reset() {
    self.model = CalcModel()
    self.mainLabel.text = String(model.res)
    self.subLabel.text = " "
  }
  
  lazy var mainLabel: UILabel = {
    let v = UILabel().autolayoutEnabled()
    v.textAlignment = .right
    v.font = UIFont.systemFont(ofSize: 40)
    v.text = String(model.res)
    return v
  }()
  lazy var subLabel: UILabel = {
    let v = UILabel().autolayoutEnabled()
    v.textAlignment = .right
    v.font = UIFont.systemFont(ofSize: 10, weight: .ultraLight)
    v.text = " "
    return v
  }()
  
  lazy var numBtns: [UIButton] = {
    let ns = Array(repeating: 0, count: 10)
    return ns.enumerated().map { (i, _) in
      let b = makeButton(text: String(i))
      b.addTarget(self, action: #selector(CalculatorViewController.onNumTapped(_:)), for: .touchUpInside)
      b.tag = i
      return b
    }
  }()
  
  lazy var addBtn: UIButton = {
    let b = makeButton(text: CalcCommand.add.rawValue)
    b.addTarget(self, action: #selector(CalculatorViewController.onAddTapped), for: .touchUpInside)
    return b
  }()
  lazy var subBtn: UIButton = {
    let b = makeButton(text: CalcCommand.sub.rawValue)
    b.addTarget(self, action: #selector(CalculatorViewController.onSubTapped), for: .touchUpInside)
    return b
  }()
  lazy var enterBtn: UIButton = {
    let b = makeButton(text: "=")
    b.addTarget(self, action: #selector(CalculatorViewController.onEnterTapped), for: .touchUpInside)
    return b
  }()
  lazy var clearBtn: UIButton = {
    let b = makeButton(text: "C")
    b.addTarget(self, action: #selector(CalculatorViewController.onClearTapped), for: .touchUpInside)
    return b
  }()

  private func setupViews() {
    let rbtns = [addBtn, subBtn, enterBtn]
    let rows = Array(repeating: 0, count: 3).enumerated().map { (i, _) -> UIStackView in
      let l = 3*i+1, r = 3*(i+1)+1
      let ns = self.numBtns[l..<r]
      let hstack = makeRowStack()
      ns.forEach { hstack.addArrangedSubview($0) }
      hstack.addArrangedSubview(rbtns[i])
      return hstack
    }
    rows.forEach { vstack.addArrangedSubview($0) }
    let bottom = makeRowStack()
    bottom.addArrangedSubview(numBtns[0])
    bottom.addArrangedSubview(clearBtn)
    vstack.addArrangedSubview(bottom)
    
    self.view.addSubview(vstack)
    self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: vstack.topAnchor, constant: -18).isActive = true
    self.view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: vstack.leftAnchor, constant: -18).isActive = true
    self.view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: vstack.rightAnchor, constant: 18).isActive = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Calculator"
    setupViews()
  }
  
  @objc func onNumTapped(_ sender: UIButton) {
    let d = sender.tag
    model.appendBuf(d)
    mainLabel.text = String(model.buf)
  }
  @objc func onAddTapped() {
    onCom(.add)
  }
  @objc func onSubTapped() {
    onCom(.sub)
  }
  
  func onCom(_ com: CalcCommand) {
    model.apply()
    model.buf = 0
    model.com = com
    mainLabel.text = String(model.res)
    subLabel.text = model.com?.rawValue ?? " "
  }
  
  @objc func onEnterTapped() {
    if model.com == nil {
      model.buf = 0
      return
    }
    model.apply()
    
    mainLabel.text = String(model.res)
    subLabel.text = " "
  }
  
  @objc func onClearTapped() {
    self.reset()
  }
}
