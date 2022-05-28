//
//  MoviesViewModel.swift
//  MoviesViewModel
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation
import Combine

class MoviesViewModel {
  
  var movies:Movies?
  
  let objectWillChange = PassthroughSubject<Void,Never>()
  var subscriptions = Set<AnyCancellable>()
  let networkManager: NetworkManagerProtocol
  
  
  init(networkManager: NetworkManagerProtocol){
    self.networkManager = networkManager
  }
  
  
  //MARK: Get movies data
  func getAllMovies() {
    let endpoint = Endpoint.movies(page: 1)
    networkManager.get(type: Movies.self, url: endpoint.url, headers: endpoint.headers).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { users in
      self.movies = users
      self.objectWillChange.send()
    })
      .store(in: &subscriptions)
  }
  
  
  func getAllMoviesFromJSON(){
    networkManager.getMovies(name: "Movies", type: Movies.self).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { movies in
      self.movies = movies
      self.objectWillChange.send()
    }).store(in: &subscriptions)
  }
  
  }
  







