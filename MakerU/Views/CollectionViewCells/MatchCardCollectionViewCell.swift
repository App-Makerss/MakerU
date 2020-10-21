//
//  MatchCardCollectionViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 14/10/20.
//

import UIKit

protocol MatchCardCollectionViewCellDelegate: class {
    func collaborateButtonTapped(_ cell: MatchCardCollectionViewCell)
}


enum CardFace {
    case front
    case back
}

class MatchCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)
    var delegate: MatchCardCollectionViewCellDelegate?
    
    var cardFace: CardFace = .front {
        didSet{
            if cardFace == .front {
                setupCardFrontalFace()
            }else {
                setupCardBackFace()
            }
        }
    }
    
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
    
    let seeMoreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        btn.setTitle("Ver tudo", for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    let cardFirstSessionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 6
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
        description.numberOfLines = 6
        return description
    }()
    
    let collaborateButton: UIControl = {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.up.circle.fill")
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 24).isActive = true
        img.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(style: .footnote, weight: .semibold)
        label.text = "Vamos Colaborar?"
        label.textColor = .systemPurple
        
        let sv = UIStackView(arrangedSubviews: [img, label])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fillProportionally
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isUserInteractionEnabled = false
        
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addSubview(sv)
        sv.topAnchor.constraint(equalTo: control.topAnchor).isActive = true
        sv.leadingAnchor.constraint(equalTo: control.leadingAnchor).isActive = true
        sv.trailingAnchor.constraint(equalTo: control.trailingAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: control.bottomAnchor).isActive = true
        
        return control
    }()
    
    private func headerContentStack() -> UIStackView {
        
        let downStack = UIStackView(arrangedSubviews: [cardSubtitle])
        //TODO: shareButton removed till sprint3
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
        
        let upStack = UIStackView(arrangedSubviews: [cardFirstSessionTitle, seeMoreButton])
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
    
    fileprivate func setupCardFrontConstraints() {
        cardFrontContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        cardFrontContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        cardFrontContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        
       collaborateButton.topAnchor.constraint(greaterThanOrEqualTo: cardFrontContent.bottomAnchor, constant: 40).isActive = true
        collaborateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        collaborateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    fileprivate func setupAppearance() {
        if cardFace == .front {
            self.backgroundColor = .systemBackground
            self.layer.cornerRadius = 10
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 50 / 2.0
            self.layer.shadowOpacity = 0.15
            self.layer.shadowOffset = CGSize(width: 0, height:10)
            
        } else {
            self.backgroundColor = .systemGray6
            self.layer.shadowOpacity = 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let cardFrontContent: UIStackView = {
        let root = UIStackView()
        root.axis = .vertical
        root.spacing = 16
        root.distribution = .fillProportionally
        
        root.translatesAutoresizingMaskIntoConstraints = false
        
        return root
    }()
    
    private let cardBackContent: UIStackView = {
        
        let label1 = UILabel()
        label1.text = "Match!"
        label1.font = UIFont(name: "Futura-Bold", size: 50)
        label1.textColor = .systemPurple
        label1.textAlignment = .center
        
        let label2 = UILabel()
        label2.text = "O contato para colaboração está disponível na área de notificações do seu perfil."
        label2.font = UIFont.systemFont(style: .callout)
        label2.numberOfLines = 0
        label2.textAlignment = .center
        
        
        let root = UIStackView(arrangedSubviews: [label1,label2])
        root.axis = .vertical
        root.distribution = .fillProportionally
        root.alignment = .center
        root.spacing = 29
        
        root.translatesAutoresizingMaskIntoConstraints = false
        
        return root
    }()
    
    private func setupCardBackFace() {
        contentView.subviews.forEach {$0.removeFromSuperview()}
        
        contentView.addSubview(cardBackContent)
        
        cardBackContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        cardBackContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        cardBackContent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        setupAppearance()
    }
    
    private func setupCardFrontalFace(){
        cardFrontContent.subviews.forEach {$0.removeFromSuperview()}
        contentView.subviews.forEach {$0.removeFromSuperview()}
        cardFrontContent.addArrangedSubview(headerStack())
        cardFrontContent.addArrangedSubview(firstSessionStack())
        cardFrontContent.addArrangedSubview(secondSessionStack())
        cardFrontContent.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cardFrontContent)
        contentView.addSubview(collaborateButton)
        
        setupAppearance()
        
        
        setupCardFrontConstraints()
        
        collaborateButton.addTarget(self, action: #selector(self.collaborateButtonTap), for: .touchUpInside)
    }
    
    
    @objc func collaborateButtonTap() {
        delegate?.collaborateButtonTapped(self)
    }
}
