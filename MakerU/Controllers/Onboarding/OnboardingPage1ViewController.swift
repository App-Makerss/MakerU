//
//  OnboardingPage1ViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class OnboardingPage1ViewController: UIViewController {

    
    //MARK: life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemPurple
        
        navigationItem.backButtonTitle = "Voltar"
        let skipButton = UIBarButtonItem(title: "Pular", style: .plain, target: self, action: #selector(self.skipTap))
        navigationItem.rightBarButtonItem = skipButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
        
    }
    
    func setupLayout() {
        let titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .title1, weight: .bold)
        titleLabel.text = "Bem vindo ao MakerU!"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.setDynamicType(textStyle: .body)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Existimos para você aproveitar ao máximo seu espaço colaborativo!"
        
        let block1 = genBlock(title: "Explore o espaço",
                              description: "Navegue pelas informações das salas e equipamentos.",
                              imageName: "magnifyingglass.circle")
        let block2 = genBlock(title: "Conheça pessoas",
                              description: "Adicione um projeto e procure interessados em colaboração.",
                              imageName: "person.2.square.stack")
        
        let blockStack = UIStackView(axis: .vertical, arrangedSubviews: [block1, block2])
        blockStack.spacing = 24
        
        let blockView = UIView()
        blockView.addSubview(blockStack)
        blockStack.setupConstraintsOnlyTo(to: blockView, leadingConstant: 16,topConstant: 0, trailingConstant: -16, bottomConstant: 0)
        
        let stackContent = UIStackView(axis: .vertical, arrangedSubviews: [titleLabel, subtitleLabel, blockView])
        stackContent.alignment = .center
        stackContent.spacing = 16
        stackContent.setCustomSpacing(46, after: subtitleLabel)
        
        let continueButton = UIButton(type: .custom)
        continueButton.setTitle("Continuar", for: .normal)
        continueButton.backgroundColor = .systemPurple
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.setDynamicType(textStyle: .headline)
        continueButton.layer.cornerRadius = 10
        
        continueButton.addTarget(self, action: #selector(self.continueTap), for: .touchUpInside)
        
        view.addSubview(stackContent)
        view.addSubview(continueButton)
        
        stackContent.setupConstraintsOnlyTo(to: view, leadingConstant: 16, topConstant: 22, trailingConstant: -16, topSafeArea: true)
        
        continueButton.setupConstraintsOnlyTo(to: view, leadingConstant: 16, trailingConstant: -16, bottomConstant: UIDevice().hasNotch ? -44 : -24, bottomSafeArea: true)
        continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        stackContent.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: -10).isActive = true
        
    }
    
    // MARK: Generation func
    private func genBlock(title: String, description: String, imageName: String ) -> UIStackView {
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .subheadline, weight: .semibold), textStyle: .subheadline)
        label.text = title
        label.numberOfLines = 0
        label.tintColor = .label
        
        let label2 = UILabel()
        label2.setDynamicType(font: .systemFont(style: .subheadline, weight: .regular), textStyle: .subheadline)
        label2.text = description
        label2.numberOfLines = 0
        label2.textColor = .secondaryLabel
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 32).isActive = true
        img.widthAnchor.constraint(equalToConstant: 34).isActive = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: imageName)
        img.tintColor = .systemPurple
        img.clipsToBounds = true
        
        
        let VStack = UIStackView(arrangedSubviews: [label,label2])
        VStack.axis = .vertical
        VStack.alignment = .leading
        
        let HStack = UIStackView(arrangedSubviews: [img,VStack])
        HStack.spacing = 20
        HStack.alignment = .center
        
        return HStack
    }
    
    //MARK: objc funcs
    @objc func skipTap() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func continueTap() {
        let nextVC = OnboardingPage2ViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
