//
//  MatchCardInfoViewController.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 22/10/20.
//

import Foundation
import UIKit

protocol MatchCardInfoViewCellDelegate: class {
    func collaborateButtonTapped(_ cell: MatchCardCollectionViewCell)
}


class MatchCardInfoViewController: UIViewController {
    
    
    //MARK: Set up View Code
    
    let cardImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 75).isActive = true
        img.widthAnchor.constraint(equalToConstant: 75).isActive = true
        img.image = UIImage(systemName: "desktopcomputer")
        img.tintColor = .purple
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    
    let cardTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(style: .title3, weight: .medium)
        title.text = "Realidade aumentada para inclusão"
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return title
    }()
    
    let cardSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.textColor = .secondaryLabel
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.text = "Tecnologia"
        subtitle.numberOfLines = 0
        return subtitle
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .systemPurple
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    let cardFirstSessionTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.text = "Descrição"
        title.tintColor = .label
        return title
    }()

    let cardFirstSessionDescription: UILabel = {
        let description = UILabel()
//        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        //description.numberOfLines = 6
        return description
    }()
    
    let cardSecondSessionTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.text = "Habilidades Procuradas"
        title.tintColor = .label
        return title
    }()
    
    let cardSecondSessionDescription: UILabel = {
        let description = UILabel()
        //description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
//        description.numberOfLines = 6
        return description
    }()
    
    private let modalContent: UIStackView = {
        let root = UIStackView()
        root.axis = .vertical
        root.spacing = 16
        root.distribution = .fillProportionally
        root.translatesAutoresizingMaskIntoConstraints = false
        
        return root
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    //MARK: Setup Functions
    
    private func headerContentStack() -> UIStackView {
        let downStack = UIStackView(arrangedSubviews: [cardSubtitle, shareButton])
        downStack.distribution = .fill
        
        let upStack = UIStackView(arrangedSubviews: [cardTitle, downStack])
        upStack.axis = .vertical
        upStack.spacing = 8
        
        let headerContent = UIStackView(arrangedSubviews: [cardImageView, upStack])
        headerContent.alignment = .center
        headerContent.spacing = 16
        return headerContent
    }
    
    private func firstSessionStack() -> UIStackView {
        let upStack = UIStackView(arrangedSubviews: [cardFirstSessionTitle])
        upStack.distribution = .fillProportionally
        
        let content = UIStackView(arrangedSubviews: [upStack, cardFirstSessionDescription])
        content.spacing = 8
        content.axis = .vertical
        
        let firstSessionStack = UIStackView(arrangedSubviews: [content, genDivider()])
        firstSessionStack.axis = .vertical
        firstSessionStack.spacing = 16
        
        return firstSessionStack
    }
    
    private func genDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.backgroundColor = .systemGray3
        return divider
    }
    
    private func secondSessionStack() -> UIStackView {
        let content = UIStackView(arrangedSubviews: [cardSecondSessionTitle, cardSecondSessionDescription])
        content.spacing = 8
        content.axis = .vertical
        
        return content
    }
    
    private func headerStack() -> UIStackView {
        let headerStack = UIStackView(arrangedSubviews: [headerContentStack(),genDivider()])
        headerStack.axis = .vertical
        headerStack.spacing = 24
        return headerStack
    }
    
    private func setupModal(){
        modalContent.subviews.forEach {$0.removeFromSuperview()}
        modalContent.addArrangedSubview(headerStack())
        scrollView.addSubview(firstSessionStack())
        scrollView.addSubview(secondSessionStack())
        modalContent.addArrangedSubview(scrollView)
//        modalContent.addArrangedSubview(firstSessionStack())
//        modalContent.addArrangedSubview(secondSessionStack())
        modalContent.translatesAutoresizingMaskIntoConstraints = false
//        setupModalConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .popover
        
        self.setupModal()
        
        view.addSubview(modalContent)
        view.backgroundColor = .systemGray6

        setupContraints()
    }
    
    func setupContraints() {
        // constraint ScrollView
        scrollView.backgroundColor = .clear
        let safeAnchors = view.safeAreaLayoutGuide
        scrollView.topAnchor.constraint(equalTo: safeAnchors.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }

}
