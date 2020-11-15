//
//  CardView.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 12/11/20.
//

import UIKit

class CardView: UIStackView{
    
    let viewTag = 200
    var seeMoreManager: SeeMoreButtonManager! = SeeMoreButtonManager()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        seeMoreManager.addOrRemoveButton()
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 16
        addArrangedSubview(genHeaderStack())
        addArrangedSubview(firstSessionStack())
        addArrangedSubview(secondSessionStack())
        
        tag = viewTag
        seeMoreManager.labels = [
            firstSectionDescription,
            secondSectionDescription
        ]
        seeMoreManager.addOrRemoveButton()
    }
    
    private var headerStack: UIStackView!
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.sizeConstraints(equalSidesConstant: 75)
        img.image = UIImage(systemName: "desktopcomputer")
        img.tintColor = .purple
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        return img
    }()
    let title: UILabel = {
        let title = UILabel()
        title.setDynamicType(textStyle: .title3, weight: .medium)
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return title
    }()
    
    let subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.textColor = .secondaryLabel
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        subtitle.setDynamicType(textStyle: .subheadline)
        subtitle.tag = 1091
        subtitle.numberOfLines = 0
        return subtitle
    }()
    
    let firstSectionTitle: UILabel = {
        let title = UILabel()
        title.setDynamicType(textStyle: .headline)
        title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        title.tintColor = .label
        title.accessibilityTraits = .header
        return title
    }()
    let firstSectionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.setDynamicType(textStyle: .callout)
        description.numberOfLines = 6
        return description
    }()
    
    let secondSectionTitle: UILabel = {
        let title = UILabel()
        title.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        title.setDynamicType(textStyle: .headline)
        title.text = "Habilidades Procuradas"
        title.tintColor = .label
        title.accessibilityTraits = .header
        return title
    }()
    
    let secondSectionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.setDynamicType(textStyle: .callout)
        description.numberOfLines = 5
        return description
    }()
    
    private func secondSessionStack() -> UIControl {
        let contentStack = UIStackView(axis: .vertical, arrangedSubviews: [secondSectionTitle, secondSectionDescription])
        contentStack.spacing = 8
        
        let uiview = UIControl()
        uiview.addSubview(contentStack)
        contentStack.setupConstraints(to: uiview)
        
        return uiview
    }
    
    private func genHeaderStack() -> UIStackView {
        
        headerStack = UIStackView(axis: .vertical, arrangedSubviews: [headerContentStack(),genDivider()])
        headerStack.tag = 1093
        headerStack.spacing = 24
        
        return headerStack
    }
    
    private func headerContentStack() -> UIStackView {
        
        let downStack = UIStackView(arrangedSubviews: [subtitle])
        downStack.tag = 1092
        //TODO: shareButton removed till sprint3
        downStack.distribution = .fill
        
        let upStack = UIStackView(axis: .vertical, arrangedSubviews: [title, downStack])
        upStack.spacing = 8
        
        let headerContent = UIStackView(arrangedSubviews: [imageView, upStack])
        headerContent.alignment = .top
        headerContent.spacing = 16
        return headerContent
    }
    
    private func firstSessionStack() -> UIStackView {
        
        let contentStack = UIStackView(axis: .vertical, arrangedSubviews: [firstSectionTitle, firstSectionDescription])
        contentStack.spacing = 8
        
        let uiview = UIControl()
        uiview.addSubview(contentStack)
        contentStack.setupConstraints(to: uiview)
        
        let firstSessionStack = UIStackView(arrangedSubviews: [uiview, genDivider()])
        firstSessionStack.axis = .vertical
        firstSessionStack.spacing = 16
        
        return firstSessionStack
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sizeCategory = traitCollection.preferredContentSizeCategory
        
        if  sizeCategory <= .large {
            if UIDevice().hasNotch{
                firstSectionDescription.numberOfLines = 6
                secondSectionDescription.numberOfLines = 5
            }else {
                firstSectionDescription.numberOfLines = 3
                secondSectionDescription.numberOfLines = 3
            }
            
            seeMoreManager.addOrRemoveButton()
            changeSubTitlePlace()
            
        }else if sizeCategory > .large &&
                    sizeCategory < .extraExtraExtraLarge {
            firstSectionDescription.numberOfLines = 4
            secondSectionDescription.numberOfLines = 4
        }else {
            if UIDevice().hasNotch{
                firstSectionDescription.numberOfLines = 3
                secondSectionDescription.numberOfLines = 3
            }else {
                firstSectionDescription.numberOfLines = 2
                secondSectionDescription.numberOfLines = 2
            }
            seeMoreManager.addOrRemoveButton()
            changeSubTitlePlace()
        }
    }
    
    func changeSubTitlePlace() {
        subtitle.removeFromSuperview()
        if title.bounds.height <= 93 {
            let foundView = viewWithTag(1092) as? UIStackView
            foundView?.addArrangedSubview(subtitle)
        }else {
            headerStack.insertArrangedSubview(subtitle, at: 1)
            headerStack.spacing = 8
            headerStack.setCustomSpacing(24, after: subtitle)
        }
    }
}
