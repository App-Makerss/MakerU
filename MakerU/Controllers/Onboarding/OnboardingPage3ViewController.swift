//
//  OnboardingPage1ViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class OnboardingPage3ViewController: UIViewController {

    
    //MARK: life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationItem.backButtonTitle = "Voltar"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        let imageView = UIImageView(image: UIImage(named: "onboardingImage2"))
        imageView.contentMode = .scaleAspectFit
        
        
        let titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .title1, weight: .bold)
        titleLabel.text = "Encontre pessoas"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.setDynamicType(textStyle: .body)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Explore projetos desenvolvidos no seu espaço e demonstre interesse em colaborar."
        
        
        let stackContent = UIStackView(axis: .vertical, arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        stackContent.alignment = .center
        stackContent.spacing = 12
        stackContent.setCustomSpacing(24, after: imageView)
        
        let continueButton = UIButton(type: .custom)
        continueButton.setTitle("Começar", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.setDynamicType(textStyle: .headline)
        continueButton.layer.cornerRadius = 10
        
        continueButton.addTarget(self, action: #selector(self.startTap), for: .touchUpInside)
        
        view.addSubview(stackContent)
        view.addSubview(continueButton)
        
        stackContent.setupConstraintsOnlyTo(to: view, leadingConstant: 16, topConstant: -5, trailingConstant: -16, topSafeArea: true)
        
        continueButton.setupConstraintsOnlyTo(to: view, leadingConstant: 16, trailingConstant: -16, bottomConstant: -44, bottomSafeArea: true)
        continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: stackContent.heightAnchor, multiplier: 0.75).isActive = true
        
        stackContent.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -70).isActive = true
    }
    
    //MARK: objc funcs
    @objc func startTap() {
        navigationController?.dismiss(animated: true)
    }

}
