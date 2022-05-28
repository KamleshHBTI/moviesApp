//
//  MovieCell.swift
//  MovieCell
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation
import UIKit
import Combine

class MovieCell: UITableViewCell{
  private var title: UILabel!
  private var overview: UILabel!
  private var poster: UIImageView!
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?

  override public func prepareForReuse() {
    super.prepareForReuse()
    poster.image = nil
    overview.text = nil
    title.text = nil
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  
  func configureMovie(movie: Movie){
    setupUI()
    title.text = movie.originalTitle
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
  
  private func setupUI() {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
    
    poster = UIImageView()
    stackView.addArrangedSubview(poster)
    NSLayoutConstraint.activate([
      poster.widthAnchor.constraint(equalToConstant: 60),
      poster.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    title = UILabel()
    title.font = .boldSystemFont(ofSize: 16)
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    
    overview = UILabel()
    overview.font = .boldSystemFont(ofSize: 11)
    overview.numberOfLines = 2
    overview.lineBreakMode = .byWordWrapping

    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.distribution = .equalSpacing
    textStackView.alignment = .leading
    textStackView.spacing = 4
    textStackView.addArrangedSubview(title)
    textStackView.addArrangedSubview(overview)
    
    stackView.addArrangedSubview(textStackView)
  }
  

}
