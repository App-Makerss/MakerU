//
//  OnboardingNavigationController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class OnboardingNavigationController: UINavigationController {

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        UserDefaults.standard.setValue(true, forKey: "onboardingAlreadySeen")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.setValue(true, forKey: "onboardingAlreadySeen")
    }
}
