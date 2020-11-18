//
//  ScrollableCover.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 23/10/20.
//
import Foundation
import UIKit

protocol ScrollableCover where Self: UIViewController {
    var scrollEdgeAppearanceTintColor: UIColor {get set}
    var defaultTintColor: UIColor {get set}
    func setupNavigationBarColor()
    func setupCoverImage(image: UIImage?)
}

extension ScrollableCover {
    
    /// Call it on viewWillAppear of the viewController it will setup the appearance of the scrollEdgeAppearance of the navigationItem
    func setupCoverImage(image: UIImage?) {
        let nav = navigationController as? ImageCoverNavigationController
        navigationItem.scrollEdgeAppearance = nav?.configureAppearance(image: image)
    }
    
    /// Call it on the init or viewDidLoad of the viewController it will setup the navigationBarColors
    func setupNavigationBarColor() {
        navigationController?.navigationBar.barTintColor  = .systemPurple
    }
    
    /// Implements scrollviewDidScroll and call this func, it will make the cover works great
    /// - Parameter scrollView: scrollView  from the scrollviewDidScroll
    func adjustCoverScroll(_ scrollView: UIScrollView) {
        guard let navBar  = self.navigationController?.navigationBar
        else {return}
        
        let navBarHeight = navBar.bounds.height
        if navBarHeight >= 46 {
            
            let backImage = UIImage(systemName: "chevron.left.circle.fill")
            navigationItem.scrollEdgeAppearance?.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
            navigationController?.navigationBar.tintColor = scrollEdgeAppearanceTintColor
        }else {
            navigationItem.scrollEdgeAppearance?.setBackIndicatorImage(nil, transitionMaskImage: nil)
            navigationController?.navigationBar.tintColor = defaultTintColor
        }
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}
