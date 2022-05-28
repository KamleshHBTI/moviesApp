//
//  UIViewController+Extension.swift
//  UIViewController+Extension
//
//  Created by Kamlesh on 28/05/22.
//

import Foundation
import UIKit

//MARK: pushview controller
extension UIViewController {
  class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
    return instantiateFromStoryboardHelper(name)
  }
  
  fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    return controller
  }
  
}

//MARK: Setup navigation bar
extension UIViewController{
  internal func setupNavigationBar(){
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    navBarAppearance.backgroundColor = UIColor(displayP3Red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1.0)
    self.navigationController?.navigationBar.standardAppearance = navBarAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    self.navigationController?.navigationBar.tintColor = .white
  }
}
