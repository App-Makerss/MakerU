//
//  ImageCoverNavigationController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 22/10/20.
//

import UIKit

class ImageCoverNavigationController: UINavigationController {
    
    func configureAppearance(image: UIImage?) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundImage = image
        appearance.backgroundImageContentMode = .scaleAspectFill
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        let backAppearance = UIBarButtonItemAppearance()
        backAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backAppearance
        let backImage = UIImage(systemName: "chevron.left.circle.fill")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        return appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.tintColor = .white
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let navBarHeight = self.navigationBar.bounds.height
        if navBarHeight >= 46{
            self.navigationBar.tintColor = .white
            return .lightContent
        } else {
            self.navigationBar.tintColor = .link
            return .default
        }
        
    }
}
