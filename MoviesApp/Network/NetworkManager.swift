//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation
import Combine

//MARK: Blue print of NetworkManagerProtocol
protocol NetworkManagerProtocol {
  typealias Headers = [String: Any]
  func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
  func getMovies<T>(name: String, type:T.Type) -> AnyPublisher<T, Error> where T: Decodable
  
}



//MARK: NetworkManager
final class NetworkManager: NetworkManagerProtocol {
  
  func get<T: Decodable>(type: T.Type,  url: URL, headers: Headers ) -> AnyPublisher<T, Error> {
    var urlRequest = URLRequest(url: url)
    headers.forEach { (key, value) in
      if let value = value as? String {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
      .map(\.data)
      .receive(on: RunLoop.main, options: nil)
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
  
  func getMovies<T>(name:String, type:T.Type) -> AnyPublisher<T, Error> where T: Decodable{
      guard
          let url = Bundle.main.url(forResource: name, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let episodes = try? JSONDecoder().decode(type.self, from: data)
      else {
          fatalError("Unable to Load Episodes")
      }

      return Just(episodes)
          .setFailureType(to: Error.self)
          .eraseToAnyPublisher()
  }
  
  
}
