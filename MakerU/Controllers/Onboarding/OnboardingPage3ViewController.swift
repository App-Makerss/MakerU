//
//  OnboardingPage1ViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class OnboardingPage3ViewController: UIViewController {
    var imageViewHeightConstraint: NSLayoutConstraint?
    let imageView = UIImageView(image: UIImage(named: "onboardingImage2"))
    
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
        
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .title1, weight: .bold)
        titleLabel.text = "Encontre pessoas"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let subtitleLabel = UILabel()
        subtitleLabel.setDynamicType(textStyle: .body)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Explore projetos desenvolvidos no seu espaço e demonstre interesse em colaborar."
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        
        let stackContent = UIStackView(axis: .vertical, arrangedSubviews: [imageView, titleLabel, subtitleLabel,UIView()])
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
        
        continueButton.setupConstraintsOnlyTo(to: view, leadingConstant: 16, trailingConstant: -16, bottomConstant: UIDevice().hasNotch ? -44 : -24, bottomSafeArea: true)
        continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.superview!.heightAnchor, multiplier: UIDevice().hasNotch ? 0.75 : 0.7)
        imageViewHeightConstraint?.isActive = true
        
        stackContent.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -10).isActive = true
    }
    
    private func manageImageViewHeight() {
        if imageView.superview != nil {
            if let imageViewHeightConstraint = imageViewHeightConstraint{
                var multiplier:CGFloat = 0
                multiplier   = traitCollection.preferredContentSizeCategory > .large ? -0.05 : 0
                multiplier += UIDevice().hasNotch ? 0.75 : 0.7
                let newC = imageViewHeightConstraint.constraintWithMultiplier(multiplier)
                imageView.superview?.removeConstraint(imageViewHeightConstraint)
                imageView.superview?.addConstraint(newC)
                self.imageViewHeightConstraint = newC
                imageView.superview?.setNeedsLayout()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        manageImageViewHeight()
    }
    
    //MARK: objc funcs
    @objc func startTap() {
        navigationController?.dismiss(animated: true)
    }

}
