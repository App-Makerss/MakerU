//
//  CardLayoutFactory.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 11/11/20.
//

import Foundation
import UIKit

struct CardLayoutFactory{
    var seeMoreAction: (()->())? = nil
    private func clear(_ view: UIView, andAdd addView: UIView) {
        view.subviews.forEach {$0.removeFromSuperview()}
        view.addSubview(addView)
    }
    
    private func setupConstraints(_ layout: UIStackView, _ view: UIView) {
        layout.setupConstraintsOnlyTo(to: view, leadingConstant: 32, trailingConstant: -32)
        layout.centerConstraints(centerYConstant: 0)
    }
    
    private func setupAppearance(ofView view: UIView, face: CardFace){
        if face == .front {
            view.superview?.layer.shadowColor = UIColor.black.cgColor
            view.superview?.layer.masksToBounds = false
            view.superview?.layer.shadowRadius = 30 / 2.0
            view.superview?.layer.shadowOpacity = 0.10
            view.superview?.layer.shadowOffset = CGSize(width: 0, height: 3)
        }else{
            view.superview?.layer.shadowOpacity = 0
        }
        view.superview?.backgroundColor = .clear
    }
    
    private func makeStandardLayout() -> (title: UILabel, subtitle: UILabel, layout: UIStackView) {
        let title = UILabel()
        title.text = "Aguardando"
        title.setDynamicType(textStyle: .headline)
        title.textAlignment = .center
        
        let subtitle = UILabel()
        subtitle.setDynamicType(textStyle: .callout)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        
        let layout = UIStackView(arrangedSubviews: [title,subtitle])
        layout.axis = .vertical
        layout.alignment = .center
        layout.spacing = 8
        layout.backgroundColor = .clear
        
        return (title,subtitle,layout)
    }
    
    private func makeBackCardLayout(inView view: UIView){
        
        let layoutComponents = makeStandardLayout()
        layoutComponents.title.text = "Match!"
        layoutComponents.title.font = UIFont(name: "Futura-Bold", size: 50)
        layoutComponents.title.adjustsFontForContentSizeCategory = true
        layoutComponents.title.textColor = .systemPurple
        
        layoutComponents.subtitle.text = "O contato para colaboração está disponível na área de notificações do seu perfil."
        layoutComponents.layout.distribution = .fillProportionally
        layoutComponents.layout.spacing = 29
        
        clear(view, andAdd: layoutComponents.layout)
        setupConstraints(layoutComponents.layout, view)
        setupAppearance(ofView: view, face: .back)
    }
    
    private func makeCardLikeLayout(inView view: UIView, cardFace: CardFace, onButtonClick: @escaping ()->()) {
        var subtitleText: String = ""
        var btnTitle: String = ""
        
        if case .likeFeedback(let value) = cardFace {
            if value == .project {
                subtitleText = "Você topou colaborar com este projeto. Espere por uma resposta para receber o contato do responsável."
                btnTitle = "Rever projeto"
            }else {
                subtitleText = "Você topou colaborar com este perfil. Espere por uma resposta para receber o contato."
                btnTitle = "Rever perfil"
            }
        }
        
        let layoutComponents = makeStandardLayout()
        layoutComponents.subtitle.text = subtitleText
        
        let btn = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            onButtonClick()
        }))
        
        btn.setTitle(btnTitle, for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        
        layoutComponents.layout.addArrangedSubview(btn)
        layoutComponents.layout.setCustomSpacing(16, after: layoutComponents.subtitle)
        
        clear(view, andAdd: layoutComponents.layout)
        setupConstraints(layoutComponents.layout, view)
        setupAppearance(ofView: view, face: cardFace)
        
    }
    
    /// <#Description#>
    /// - Parameter view: <#view description#>
    private func makeCardNothingLayout(inView view: UIView) {
        let layoutComponents = makeStandardLayout()
        layoutComponents.title.text = "Ninguém para colaborar :("
        layoutComponents.subtitle.text = "Seu espaço ainda não possui pessoas ou projetos interessados em colaboração. Seja o primeiro a exibir publicamente seu perfil ou projeto!"
        
        clear(view, andAdd: layoutComponents.layout)
        setupConstraints(layoutComponents.layout, view)
        setupAppearance(ofView: view, face: .nothingFeedback)
    }
    
    /// Make the card layout depending  on cardFace and adds it some view
    /// - Parameters:
    ///   - view: where to add the layout as subview
    ///   - cardFace: the face to be made
    ///   - seeMoreAction: action for seeMoreButtons
    ///   - collaborateAction: action for collaborateButton
    func makeCardLayout(inView view: UIView, cardFace: CardFace, seeMoreAction: (()->())? = nil, collaborateAction: (()->())? = nil) {
        switch cardFace {
            case .back:
                makeBackCardLayout(inView: view)
            case .likeFeedback:
                makeCardLikeLayout(
                    inView: view,
                    cardFace: cardFace,
                    onButtonClick: seeMoreAction!)
            case .nothingFeedback:
                makeCardNothingLayout(inView: view)
            default:
                makeFrontCardLayout(inView: view,
                                    collaborateAction: collaborateAction!, seeMoreAction: seeMoreAction!)
        }
    }
    
    /// Generates a collaborate button using stackView to group an image and a label
    /// - Returns: a uiControl to be used as a button (adding targets, or actions)
    private func genCollaborateButton() -> UIControl {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.up.circle.fill")
        img.tintColor = .label
        img.sizeConstraints(equalSidesConstant: 24)
        
        let label = UILabel()
        label.setDynamicType(textStyle: .footnote, weight: .semibold)
        label.text = "Vamos Colaborar?"
        label.accessibilityTraits = .button
        label.textColor = .systemPurple
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        let sv = UIStackView(axis: .vertical, arrangedSubviews: [img, label])
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.isUserInteractionEnabled = false
        
        let collaborateButton = UIControl()
        collaborateButton.translatesAutoresizingMaskIntoConstraints = false
        collaborateButton.addSubview(sv)
        sv.setupConstraints(to: collaborateButton)
        return collaborateButton
    }
    
    
    /// Constructs the layout of MatchCard for front card face
    /// - Parameters:
    ///   - view: in where the layout will be added as subview
    ///   - collaborateAction: action when collaborateButton be tapped
    ///   - seeMoreAction: action when seeMoreButton be tapped
    private func makeFrontCardLayout(inView view: UIView, collaborateAction: @escaping ()->(), seeMoreAction: @escaping ()->()){
        let containerview = UIView()
        let cardView = CardView()
        cardView.seeMoreManager.seeMoreAction = seeMoreAction
        let collaborateButton = genCollaborateButton()
        
        containerview.layer.cornerRadius = 10
        containerview.layer.masksToBounds = true
        containerview.backgroundColor = .secondarySystemGroupedBackground
        
        containerview.addSubview(cardView)
        containerview.addSubview(collaborateButton)
        
        collaborateButton.addAction(UIAction(handler: { _ in
            collaborateAction()
        }), for: .touchUpInside)
        clear(view, andAdd: containerview)
        
        cardView.setupConstraintsOnlyTo(to: containerview, leadingConstant: 24, topConstant: 24, trailingConstant: -24 )

        collaborateButton.centerConstraints(centerXConstant: 0)
        collaborateButton.setupConstraintsOnlyTo(to: containerview, bottomConstant: -16)
        
        collaborateButton.topAnchor.constraint(greaterThanOrEqualTo: cardView.bottomAnchor, constant: 20).isActive = true
        
        containerview.setupConstraints(to: view)
        
        setupAppearance(ofView: view, face: .front)
    }
    
}
