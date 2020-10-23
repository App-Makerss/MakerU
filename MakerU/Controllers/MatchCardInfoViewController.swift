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
    
    func config(with matchCard: MatchCard) {
        cardTitle.text = matchCard.title
        cardSubtitle.text = matchCard.subtitle
        cardImageView.image = matchCard.image
        
        cardFirstSessionTitle.text = matchCard.firstSessionTitle
        cardFirstSessionDescription.text = matchCard.firstSessionLabel
        cardSecondSessionTitle.text = matchCard.secondSessionTitle
        cardSecondSessionDescription.text = matchCard.secondSessionLabel
    }
    
    //MARK: View Code Set up
    
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
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 0
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
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 0
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
        scroll.isScrollEnabled = true
        scroll.isDirectionalLockEnabled = true
        scroll.alwaysBounceVertical = true
        
        return scroll
    }()
    
    //MARK: Functions Set up
    
    private func headerContentStack() -> UIStackView {
        let downStack = UIStackView(arrangedSubviews: [cardSubtitle, shareButton])
        downStack.distribution = .fill
        
        let upStack = UIStackView(arrangedSubviews: [cardTitle, downStack])
        upStack.axis = .vertical
        upStack.spacing = 8
        
        let headerContent = UIStackView(arrangedSubviews: [cardImageView, upStack])
        headerContent.alignment = .top
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
    
    
    private func setupScroll(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        modalContent.translatesAutoresizingMaskIntoConstraints = false
        modalContent.addArrangedSubview(firstSessionStack())
        modalContent.addArrangedSubview(secondSessionStack())
        view.addSubview(scrollView)
        scrollView.addSubview(modalContent)
    }
    
    //MARK: Controller Set Up
    @objc func closeTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeTapped))
        self.navigationItem.rightBarButtonItem = close
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.modalPresentationStyle = .popover
        
        let header = headerStack()
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        self.setupScroll()
        
        view.backgroundColor = .systemGray6

        setupContraints(header: header)
    }
    
    func setupContraints(header: UIView) {
        
        header.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 29).isActive = true
        header.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -16).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        modalContent.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        modalContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        modalContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        modalContent.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        modalContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }

}
