//
//  network.swift
//  maybe-mock-app
//
//  Created by Hiroshi Kori on 6/6/19.
//  Copyright © 2019 Hiroshi Kori. All rights reserved.
//

import Foundation

let endpoint = "https://private-1b6238-iosmockapp.apiary-mock.com"

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
}

enum NetworkResponse<Model> {
  case success(Model?)
  case failure(Error)
}

func makeRequest<Model: Decodable>(path: String, method: HttpMethod, handler: @escaping (NetworkResponse<Model>) -> Void) {
  let url = URL(string: endpoint + path)!
  var req = URLRequest(url: url)
  req.httpMethod = method.rawValue
  let dataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
    let res: NetworkResponse<Model>
    if let err = error {
      res = .failure(err)
    } else {
      let dec = JSONDecoder()
      let m = data.flatMap { try? dec.decode(Model.self, from: $0) }
      res = .success(m)
    }
    DispatchQueue.main.async { handler(res) }
  }
  dataTask.resume()
}
