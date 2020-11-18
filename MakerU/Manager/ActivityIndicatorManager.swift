//
//  ActivityIndicatorManager.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/11/20.
//

import UIKit
class ActivityIndicatorManager {
    
    var rightBarButtons: [UIBarButtonItem] = []
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    func startLoading(on navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.setRightBarButton(barButton, animated: true)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading(on navigationItem: UINavigationItem) {
        self.activityIndicator.stopAnimating()
        navigationItem.setRightBarButtonItems(self.rightBarButtons, animated: true)
    }
}
