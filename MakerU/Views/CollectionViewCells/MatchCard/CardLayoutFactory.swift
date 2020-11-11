//
//  CardLayoutFactory.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 11/11/20.
//

import Foundation
import UIKit

struct CardLayoutFactory{
    private func clear(_ view: UIView, andAdd addView: UIView) {
        view.subviews.forEach {$0.removeFromSuperview()}
        view.addSubview(addView)
    }
    
    private func setupConstraints(_ layoutComponents: (title: UILabel, subtitle: UILabel, layout: UIStackView), _ view: UIView) {
        layoutComponents.layout.setupConstraintsOnlyTo(to: view, leadingConstant: 32, trailingConstant: -32)
        layoutComponents.layout.centerConstraints(centerYConstant: 0)
    }
    
    private func setupAppearance(ofView view: UIView){
        view.superview?.backgroundColor = .systemGray6
        view.superview?.layer.shadowOpacity = 0
    }
    
    private func makeStandardLayout() -> (title: UILabel, subtitle: UILabel, layout: UIStackView) {
        let title = UILabel()
        title.text = "Aguardando"
        title.setDynamicType(font: .systemFont(style: .headline))
        title.textAlignment = .center
        
        let subtitle = UILabel()
        subtitle.setDynamicType(font: .systemFont(style: .callout))
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        
        let layout = UIStackView(arrangedSubviews: [title,subtitle])
        layout.axis = .vertical
        layout.alignment = .center
        layout.spacing = 8
        
        return (title,subtitle,layout)
    }
    
    func makeCardLayout(inView view: UIView, cardFace: CardFace, onButtonClick: @escaping (()->())) {
        switch cardFace {
            case .back:
                makeBackCardLayout(inView: view)
            case .likeFeedback:
                makeCardLikeLayout(
                    inView: view,
                    cardFace: cardFace, onButtonClick: onButtonClick)
            case .nothingFeedback:
                makeCardNothingLayout(inView: view)
            default:
                break
        }
    }
    
    func makeBackCardLayout(inView view: UIView){

        let layoutComponents = makeStandardLayout()
        layoutComponents.title.text = "Match!"
        layoutComponents.title.font = UIFont(name: "Futura-Bold", size: 50)
        layoutComponents.title.adjustsFontForContentSizeCategory = true
        layoutComponents.title.textColor = .systemPurple
        
        layoutComponents.subtitle.text = "O contato para colaboração está disponível na área de notificações do seu perfil."
        layoutComponents.layout.distribution = .fillProportionally
        layoutComponents.layout.spacing = 29
        
        clear(view, andAdd: layoutComponents.layout)
        setupConstraints(layoutComponents, view)
        setupAppearance(ofView: view)
    }
    
    func makeCardLikeLayout(inView view: UIView, cardFace: CardFace, onButtonClick: @escaping ()->()) {
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
        setupConstraints(layoutComponents, view)
        setupAppearance(ofView: view)
        
    }
    
    func makeCardNothingLayout(inView view: UIView) {
        let layoutComponents = makeStandardLayout()
        layoutComponents.title.text = "Ninguém para colaborar :("
        layoutComponents.subtitle.text = "Seu espaço ainda não possui pessoas ou projetos interessados em colaboração. Seja o primeiro a exibir publicamente seu perfil ou projeto!"
        
        clear(view, andAdd: layoutComponents.layout)
        setupConstraints(layoutComponents, view)
        setupAppearance(ofView: view)
    }
    
}
