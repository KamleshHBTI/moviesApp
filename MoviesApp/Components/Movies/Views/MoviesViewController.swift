//
//  ViewController.swift
//  MoviesApp
//
//  Created by Kamlesh on 28/05/22.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {

  lazy var movieList: UITableView = {
    let tblView = UITableView()
    tblView.delegate = self
    tblView.dataSource = self
    tblView.register(MovieCell.self, forCellReuseIdentifier: "cell")
    return tblView
  }()
  
  var subscriptions = Set<AnyCancellable>()
  private var cancellable: Set<AnyCancellable> = []
  
  
  lazy var viewModel = MoviesViewModel(networkManager: NetworkManager())

  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindViewModel()
    viewModel.getAllMoviesFromJSON()
  }
  
  private func configureUI(){
    setupNavigationBar()
    setupTblView()
  }
  
  private func setupTblView(){
    view.addSubview(movieList)
    movieList.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [movieList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                       movieList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                       movieList.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
                       movieList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  //MARK: viewModel Binding
  private func bindViewModel() {
    viewModel.objectWillChange.sink { [weak self] in
      guard let _ = self else {
        return
      }
      self?.movieList.reloadData()
    }.store(in: &cancellable)
  }
}

//MARK: UITableView UITableViewDelegate
extension MoviesViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = MovieDetailController.instantiateFromStoryboard()
    guard let movie = viewModel.movies?.results[indexPath.row] else {
      return
    }
    vc.movie = movie
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: UITableView UITableViewDataSource
extension MoviesViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.movies?.results.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieCell else {
      fatalError()
    }
    cell.configureMovie(movie: (viewModel.movies?.results[indexPath.row])!)
    return cell
  }
  
  
}


  

