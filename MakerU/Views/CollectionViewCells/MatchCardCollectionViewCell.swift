//
//  MatchCardCollectionViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 14/10/20.
//

import UIKit

protocol MatchCardCollectionViewCellDelegate: class {
    func collaborateButtonTapped(_ cell: MatchCardCollectionViewCell)
    func seeMoreButtonButtonTapped(_ cell: MatchCardCollectionViewCell)
    func showCardSwiped(_ cell: MatchCardCollectionViewCell)
}

enum CardFace: Equatable {
    case front
    case back
    case likeFeedback(MatchCardType)
}

class MatchCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)

    var delegate: MatchCardCollectionViewCellDelegate?

    var cardFace: CardFace = .front {
        didSet{
            switch cardFace {
                case .back:
                    setupCardBackFace()
                case .likeFeedback:
                    setupCardLikeFeedback()
                default:
                    setupCardFrontalFace()
                    addOrRemoveButton()
            }
        }
    }

    public func showSwipeUp(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 1
        containerview.isUserInteractionEnabled = true
        containerview.addGestureRecognizer(gesture)
    }

    @objc func swipeUp(){
        delegate?.showCardSwiped(self)
    }
    let containerview = UIView()
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
    var cardLikeFeedbackContent: UIStackView! = nil
    
    let cardTitle: UILabel = {
        let title = UILabel()
        title.setDynamicType(font: .systemFont(style: .title3, weight: .medium), textStyle: .title3)
        title.text = "Realidade aumentada para inclusão"
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return title
    }()
    
    let cardSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.textColor = .secondaryLabel
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        subtitle.setDynamicType(font: .systemFont(style: .subheadline))
        subtitle.tag = 1091
        subtitle.text = "Tecnologia"
        subtitle.numberOfLines = 0
        return subtitle
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .systemPurple
        btn.contentHorizontalAlignment = .right
        btn.isHidden = true
        return btn
    }()
    
    let cardFirstSessionTitle: UILabel = {
        let title = UILabel()
        title.setDynamicType(font: .systemFont(style: .headline))
        title.text = "Descrição"
        title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        title.tintColor = .label
        title.accessibilityTraits = .header
        return title
    }()
    let seeMoreButton: UIButton = {
        let btn = genSeeMoreButton()
        return btn
    }()
    private static func genSeeMoreButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.setDynamicType(font: .systemFont(style: .subheadline))
        btn.setTitle("mais", for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.isEnabled = true
        btn.setBackgroundImage(UIImage(named: "seeMoreButtonBackgroundGradient"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    let seeMoreButton1: UIButton = {
        let btn = genSeeMoreButton()
        return btn
    }()
    
    let cardFirstSessionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.setDynamicType(font: .systemFont(style: .callout))
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 6
        return description
    }()
    
    let cardSecondSessionTitle: UILabel = {
        let title = UILabel()
        title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        title.setDynamicType(font: .systemFont(style: .headline))
        title.text = "Habilidades Procuradas"
        title.tintColor = .label
        title.accessibilityTraits = .header
        return title
    }()
    
    let cardSecondSessionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.setDynamicType(font: .systemFont(style: .callout))
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 5
        return description
    }()
    
    let collaborateButton: UIControl = {
        let img = UIImageView()
        img.image = UIImage(systemName: "chevron.up.circle.fill")
        img.tintColor = .label
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 24).isActive = true
        img.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .footnote, weight: .semibold), textStyle: .footnote)
        label.text = "Vamos Colaborar?"
        label.accessibilityTraits = .button
        label.textColor = .systemPurple
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
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
        downStack.tag = 1092
        //TODO: shareButton removed till sprint3
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
        
        
        let contentStack = UIStackView(arrangedSubviews: [cardFirstSessionTitle, cardFirstSessionDescription])
        contentStack.spacing = 8
        contentStack.axis = .vertical
        
        let uiview = UIControl()
        uiview.addSubview(contentStack)
        contentStack.setupConstraints(to: uiview)
        
        let firstSessionStack = UIStackView(arrangedSubviews: [uiview, genDivider()])
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
    
    private func secondSessionStack() -> UIControl {
        let contentStack = UIStackView(arrangedSubviews: [cardSecondSessionTitle, cardSecondSessionDescription])
        contentStack.spacing = 8
        contentStack.axis = .vertical
        
        let uiview = UIControl()
        uiview.addSubview(contentStack)
        contentStack.setupConstraints(to: uiview)
        
        return uiview
    }
    
    private func headerStack() -> UIStackView {
        
        let headerStack = UIStackView(arrangedSubviews: [headerContentStack(),genDivider()])
        headerStack.tag = 1093
        headerStack.axis = .vertical
        headerStack.spacing = 24
        return headerStack
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let buttonAray =  self.superview?.subviews.filter({ (subViewObj) -> Bool in
            return subViewObj.tag == 9090 || subViewObj.tag == 9091
        })
        
        if buttonAray?.isEmpty == true {
            self.addOrRemoveButton()
        }
        showSwipeUp()
    }
    
    fileprivate func configFirstSectionSeeMoreButton(_ uiview: UIControl, _ contentStack: UIView) {
        if cardFirstSessionDescription.isTruncated{
            addAndConfigButton(seeMoreButton, uiview, contentStack, tag: 9090)
        }else {
            uiview.removeTarget(self, action: #selector(self.seeMoreButtonTap), for: .touchUpInside)
            seeMoreButton.removeFromSuperview()
        }
    }
    
    fileprivate func configSecondSectionSeeMoreButton(_ uiview: UIControl, _ contentStack: UIView) {
        if cardSecondSessionDescription.isTruncated{
            
            addAndConfigButton(seeMoreButton1, uiview, contentStack, tag: 9091)
            
        }else {
            uiview.removeTarget(self, action: #selector(self.seeMoreButtonTap), for: .touchUpInside)
            seeMoreButton1.removeFromSuperview()
        }
    }
    
    fileprivate func addAndConfigButton(_ button: UIButton, _ uiview: UIControl, _ contentStack: UIView, tag: Int) {
        contentStack.isUserInteractionEnabled = false

        uiview.addSubview(button)
        uiview.isUserInteractionEnabled = true
        uiview.addTarget(self, action: #selector(self.seeMoreButtonTap), for: .touchUpInside)
        
        button.tag = tag
        button.trailingAnchor.constraint(equalTo: uiview.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: uiview.widthAnchor, multiplier: 0.2).isActive = true
        button.lastBaselineAnchor.constraint(equalTo: contentStack.lastBaselineAnchor).isActive = true
        button.isUserInteractionEnabled = false
        button.isAccessibilityElement = false
        
        
    }
    
    func addOrRemoveButton() {
        if let uiview = cardFirstSessionDescription.superview?.superview as? UIControl,
           let contentStack = uiview.subviews.first{
            configFirstSectionSeeMoreButton(uiview, contentStack)
        }
        if let uiview = cardSecondSessionDescription.superview?.superview as? UIControl,
           let contentStack = uiview.subviews.first{
            configSecondSectionSeeMoreButton(uiview, contentStack)
        }
    }
    
    fileprivate func setupCardFrontConstraints() {
        cardFrontContent.topAnchor.constraint(equalTo: containerview.topAnchor, constant: 24).isActive = true
        cardFrontContent.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -24).isActive = true
        cardFrontContent.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: 24).isActive = true
        
       collaborateButton.topAnchor.constraint(greaterThanOrEqualTo: cardFrontContent.bottomAnchor, constant: 20).isActive = true
        collaborateButton.centerXAnchor.constraint(equalTo: containerview.centerXAnchor).isActive = true
        collaborateButton.bottomAnchor.constraint(equalTo: containerview.bottomAnchor, constant: -16).isActive = true
    }
    
    fileprivate func setupAppearance() {
        if cardFace == .front {
            self.backgroundColor = .clear
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 30 / 2.0
            self.layer.shadowOpacity = 0.10
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            
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
        label1.adjustsFontForContentSizeCategory = true
        label1.textColor = .systemPurple
        label1.textAlignment = .center
        
        let label2 = UILabel()
        label2.text = "O contato para colaboração está disponível na área de notificações do seu perfil."
        label2.setDynamicType(font: .systemFont(style: .callout))
        label2.numberOfLines = 0
        label2.textAlignment = .center
        
        
        let root = UIStackView(arrangedSubviews: [label1,label2])
        root.axis = .vertical
        root.distribution = .fillProportionally
        root.alignment = .center
        root.spacing = 29
        
        return root
    }()
    
    func genLikeFeedbackContent() -> UIStackView {
        var label2Text: String = ""
        var btnTitle: String
        
        if case .likeFeedback(let value) = cardFace {
            
        }
        switch cardFace{
            case .likeFeedback(let type):
                if type == .project {
                    label2Text = "Você topou colaborar com este projeto. Espere por uma resposta para receber o contato do responsável."
                    btnTitle = "Rever projeto"
                }else {
                    label2Text = "Você topou colaborar com este perfil. Espere por uma resposta para receber o contato."
                    btnTitle = "Rever perfil"
                }
            default:
                btnTitle = "Deu Ruim"
        }
        let label1 = UILabel()
        label1.text = "Aguardando"
        label1.setDynamicType(font: .systemFont(style: .headline))
        label1.textAlignment = .center
        
        let label2 = UILabel()
        label2.text = label2Text
        label2.setDynamicType(font: .systemFont(style: .callout))
        label2.textColor = .secondaryLabel
        label2.numberOfLines = 0
        label2.textAlignment = .center
        
        let btn = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.cardFace = .front
        }))
        
        btn.setTitle(btnTitle, for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        
        
        let root = UIStackView(arrangedSubviews: [label1,label2,btn])
        root.axis = .vertical
        root.alignment = .center
        root.spacing = 8
        root.setCustomSpacing(16, after: label2)
        
        return root
    }
    
    private func setupCardBackFace() {
        contentView.subviews.forEach {$0.removeFromSuperview()}
        
        contentView.addSubview(cardBackContent)
        
        cardBackContent.setupConstraintsOnlyTo(to: contentView, leadingConstant: 32, trailingConstant: -32)
        cardBackContent.centerConstraints(centerYConstant: 0)
        
        setupAppearance()
    }
    
    private func setupCardLikeFeedback() {
        contentView.subviews.forEach {$0.removeFromSuperview()}
        cardLikeFeedbackContent = genLikeFeedbackContent()
        
        contentView.addSubview(cardLikeFeedbackContent)
        
        cardLikeFeedbackContent.setupConstraintsOnlyTo(to: contentView, leadingConstant: 32, trailingConstant: -32)
        cardLikeFeedbackContent.centerConstraints(centerYConstant: 0)
        
        setupAppearance()
    }

    private func setupCardFrontalFace(){
        cardFrontContent.subviews.forEach {$0.removeFromSuperview()}
        contentView.subviews.forEach {$0.removeFromSuperview()}
        cardFrontContent.addArrangedSubview(headerStack())
        cardFrontContent.addArrangedSubview(firstSessionStack())
        cardFrontContent.addArrangedSubview(secondSessionStack())
        cardFrontContent.translatesAutoresizingMaskIntoConstraints = false
        
        containerview.layer.cornerRadius = 10
        containerview.layer.masksToBounds = true
        containerview.backgroundColor = .secondarySystemGroupedBackground
        containerview.translatesAutoresizingMaskIntoConstraints = false

        containerview.addSubview(cardFrontContent)
        containerview.addSubview(collaborateButton)
        
        contentView.addSubview(containerview)
        
        containerview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerview.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        setupAppearance()
        setupCardFrontConstraints()
        
        collaborateButton.addTarget(self, action: #selector(self.collaborateButtonTap), for: .touchUpInside)
    }
    
    @objc func collaborateButtonTap() {
        delegate?.collaborateButtonTapped(self)
    }
    
    @objc func seeMoreButtonTap() {
        delegate?.seeMoreButtonButtonTapped(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sizeCategory = traitCollection.preferredContentSizeCategory
        
        if  sizeCategory <= .large {
            if UIDevice().hasNotch{
                cardFirstSessionDescription.numberOfLines = 6
                cardSecondSessionDescription.numberOfLines = 5
            }else {
                cardFirstSessionDescription.numberOfLines = 3
                cardSecondSessionDescription.numberOfLines = 3
            }
            
            addOrRemoveButton()
            changeSubTitlePlace()
            
        }else if sizeCategory > .large &&
                    sizeCategory < .extraExtraExtraLarge {
            cardFirstSessionDescription.numberOfLines = 4
            cardSecondSessionDescription.numberOfLines = 4
        }else {
            if UIDevice().hasNotch{
                cardFirstSessionDescription.numberOfLines = 3
                cardSecondSessionDescription.numberOfLines = 3
            }else {
                cardFirstSessionDescription.numberOfLines = 2
                cardSecondSessionDescription.numberOfLines = 2
            }
            addOrRemoveButton()
            changeSubTitlePlace()
        }
    }
    
    func changeSubTitlePlace() {
        if cardTitle.bounds.height <= 93 {
            let foundView = viewWithTag(1092) as? UIStackView
            cardSubtitle.removeFromSuperview()
            foundView?.addArrangedSubview(cardSubtitle)
        }else {
            let headerStack = viewWithTag(1093) as? UIStackView
            cardSubtitle.removeFromSuperview()
            headerStack?.insertArrangedSubview(cardSubtitle, at: 1)
            headerStack?.spacing = 8
            headerStack?.setCustomSpacing(24, after: cardSubtitle)
            
        }
    }
    
}
