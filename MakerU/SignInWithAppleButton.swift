//
//  SignInWithAppleButton.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/11/20.
//

import AuthenticationServices
import UIKit

@available(iOS 13.0, *)
class SignInWithAppleButton: UIControl {
    var cornerRadius: CGFloat = 0.0 { didSet { updateRadius() } }
    private var target: Any?
    private var action: Selector?
    private var controlEvents: UIControl.Event = .touchUpInside
    private var whiteButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    private var blackButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
     init(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        super.init(frame: .zero)
        addTarget(target, action: action, for: controlEvents)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.target = target
        self.action = action
        self.controlEvents = controlEvents
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupButton()
    }
}

// MARK: - Private Methods
@available(iOS 13.0, *)
private extension SignInWithAppleButton {
    func setupButton() {
        switch traitCollection.userInterfaceStyle {
            case .dark:
                subviews.forEach { $0.removeFromSuperview() }
                addSubview(whiteButton)
                whiteButton.setupConstraints(to: self)
                whiteButton.cornerRadius = cornerRadius
                action.map { whiteButton.addTarget(target, action: $0, for: controlEvents) }
            case _:
                subviews.forEach { $0.removeFromSuperview() }
                addSubview(blackButton)
                blackButton.setupConstraints(to: self)
                blackButton.cornerRadius = cornerRadius
                action.map { blackButton.addTarget(target, action: $0, for: controlEvents) }
        }
    }
    
    func updateRadius() {
        switch traitCollection.userInterfaceStyle {
            case .dark:
                whiteButton.cornerRadius = cornerRadius
            case _:
                blackButton.cornerRadius = cornerRadius
        }
    }
}

