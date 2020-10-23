//
//  MatchOnboardingViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 22/10/20.
//

import UIKit

final class MatchOnboardingViewController: UIViewController {

    private func genBlock(title: String, description: String, imageName: String ) -> UIStackView {
        let label = UILabel()
        label.font = UIFont.systemFont(style: .subheadline, weight: .semibold)
        label.text = title
        label.numberOfLines = 0
        label.tintColor = .label

        let label2 = UILabel()
        label2.font = UIFont.systemFont(style: .subheadline)
        label2.text = description
        label2.numberOfLines = 0
        label2.tintColor = .secondaryLabel

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: imageName)
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        let img = UILabel()
        img.attributedText = fullString
        img.font = .systemFont(style: .title1)
        img.tintColor = .systemPurple

        let VStack = UIStackView(arrangedSubviews: [label,label2])
        VStack.axis = .vertical
        VStack.alignment = .leading

        let HStack = UIStackView(arrangedSubviews: [img,VStack])
        HStack.spacing = 20
        HStack.alignment = .center

        return HStack
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)

        let content = genContent()
        scroll.addSubview(content)

        setupConstraint(scroll, content)
    }

   private func genContent() -> UIStackView {
        let title = UILabel()
        title.font = .systemFont(style: .title1, weight: .bold)
        title.text = "Funcionalidades do Match"
        title.numberOfLines = 0
        title.tintColor = .label

        let subtitle = UILabel()
        subtitle.font = .systemFont(style: .body)
        subtitle.text = "Encontre projetos para colaborar ou colaboradores para seu projeto!"
        subtitle.numberOfLines = 0
        subtitle.tintColor = .label

        let block1 = genBlock(title: "Explore projetos e perfis", description: "Para visualizar o card seguinte, deslize o dedo para o lado.", imageName: "square.stack")
        let block2 = genBlock(title: "Deslize para cima", description: "Para manifestar interesse em colaborar, deslize o dedo para cima sobre o card.", imageName: "chevron.up.circle")
        let block3 = genBlock(title: "Habilite sua exibição", description: "Para ser visto por outros usuários habilite sua exibição em configurações de exibição.", imageName: "eye")
        let block4 = genBlock(title: "Cheque as notificações", description: "Em caso de match, o contato para colaboração estará disponível na área de notificações do seu perfil.", imageName: "bell")

        let blocksVStack = UIStackView(arrangedSubviews: [block1, block2, block3, block4])
        blocksVStack.axis = .vertical

        let VStack = UIStackView(arrangedSubviews: [title, subtitle, blocksVStack])
        VStack.axis = .vertical
        VStack.spacing = 16
        VStack.setCustomSpacing(46, after: subtitle)
        VStack.translatesAutoresizingMaskIntoConstraints = false

        return VStack
    }

    private func setupConstraint(_ scroll: UIScrollView, _ content: UIStackView) {
        let safeAnchors = view.safeAreaLayoutGuide
        scroll.topAnchor.constraint(equalTo: safeAnchors.topAnchor, constant: 34).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true

        content.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
    }
}
