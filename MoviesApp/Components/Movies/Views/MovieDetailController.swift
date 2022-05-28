//
//  MovieDetailController.swift
//  MovieDetailController
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation
import UIKit
import Combine

class MovieDetailController: UIViewController{
  var movie:Movie!
  
  @IBOutlet var name: UILabel!
  @IBOutlet var rating: UILabel!
  @IBOutlet var popularity: UILabel!
  @IBOutlet var poster: UIImageView!
  @IBOutlet var overview: UILabel!
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureMovie(movie: movie)
  }
  
  func configureMovie(movie: Movie){
    name.text = movie.title
    rating.text = movie.voteAverage.toString()
    popularity.text = movie.popularity.toString()
    overview.text = movie.overview
    cancellable = loadImage(for: movie).sink { [unowned self] image in self.showImage(image: image) }
  }
  
  private func loadImage(for movie: Movie) -> AnyPublisher<UIImage?, Never> {
    let path = basPath + movie.posterPath
    return Just(path)
      .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
        let url = URL(string: path)
        return ImageLoader.shared.loadImage(from: url ?? URL(fileURLWithPath: ""))
      })
      .eraseToAnyPublisher()
  }

  private func showImage(image: UIImage?) {
    poster.alpha = 0.0
    animator?.stopAnimation(false)
    poster.image = (image != nil) ? image : UIImage(named: "img")
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.poster.alpha = 1.0
    })
  }
  
}
