//
//  EndPoints.swift
//  EndPoints
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation

struct Endpoint {
  var path: String
  var queryItems: [URLQueryItem] = []
}

extension Endpoint {
  static let apiKey = "38a73d59546aa378980a88b645f487fc"

  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.themoviedb.org/3"
    components.path = "/movie/popular?api_key=" + path
    components.queryItems = queryItems
    
    guard let url = components.url?.absoluteURL else {
      preconditionFailure("Invalid URL components: \(components)")
    }
    return url
  }
  
  var headers: [String: Any] {
    return [
      "Content-Type": "Application/json"
    ]
  }
}

extension Endpoint {
  //MARK: movies end points
  static func movies(page: Int) -> Self {
    return Endpoint(path: "\(Endpoint.apiKey)",  queryItems: [ URLQueryItem(name: "language=", value: "en-US"),URLQueryItem(name: "page=", value: "\(page)") ])
  }
}

enum FailureReason : Error {
    case decoding(description: String)
    case api(description: String)
}
