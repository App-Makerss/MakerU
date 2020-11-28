//
//  OnboardingPage1ViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class OnboardingPage2ViewController: UIViewController {

    
    //MARK: life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationItem.backButtonTitle = "Voltar"
        let skipButton = UIBarButtonItem(title: "Pular", style: .plain, target: self, action: #selector(self.skipTap))
        navigationItem.rightBarButtonItem = skipButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        let imageView = UIImageView(image: UIImage(named: "onboardingImage1"))
        imageView.contentMode = .scaleAspectFit
        
        
        let titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .title1, weight: .bold)
        titleLabel.text = "Explore seu espaço"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let subtitleLabel = UILabel()
        subtitleLabel.setDynamicType(textStyle: .body)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Efetue uma reserva para agendar o uso das salas e equipamentos."
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let stackContent = UIStackView(axis: .vertical, arrangedSubviews: [imageView, titleLabel, subtitleLabel,UIView()])
        stackContent.alignment = .center
        stackContent.spacing = 12
        stackContent.setCustomSpacing(24, after: imageView)
        
        let continueButton = UIButton(type: .custom)
        continueButton.setTitle("Continuar", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.setDynamicType(textStyle: .headline)
        continueButton.layer.cornerRadius = 10
        
        continueButton.addTarget(self, action: #selector(self.continueTap), for: .touchUpInside)
        
        view.addSubview(stackContent)
        view.addSubview(continueButton)
        
        stackContent.setupConstraintsOnlyTo(to: view, leadingConstant: 16, topConstant: -5, trailingConstant: -16, topSafeArea: true)
        
        continueButton.setupConstraintsOnlyTo(to: view, leadingConstant: 16, trailingConstant: -16, bottomConstant: UIDevice().hasNotch ? -44 : -24, bottomSafeArea: true)
        continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: stackContent.heightAnchor, multiplier: UIDevice().hasNotch ? 0.75 : 0.7).isActive = true
        
        stackContent.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: UIDevice().hasNotch ? -40 : -20).isActive = true
        
    }
    
    //MARK: objc funcs
    @objc func skipTap() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func continueTap() {
        let nextVC = OnboardingPage3ViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
