//
//  CalculatorModel.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/24/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

enum CalcCommand: String {
  case add = "+", sub = "-"
}

class CalcModel {
  var res: Int = 0
  var buf: Int = 0
  var com: CalcCommand?
  
  init() {
    self.res = 0
    self.buf = 0
    self.com = nil
  }
  
  func appendBuf(_ d: Int) {
    var v = Int64(self.buf)
    v = v * 10 + Int64(d)
    guard let vv = Int32(exactly: v) else { return }
    self.buf = Int(vv)
  }
  
  func apply() {
    guard let c = com else {
      res=buf
      return
    }
    switch c {
    case .add:
      res+=buf
    case .sub:
      res-=buf
    }
  }
}
