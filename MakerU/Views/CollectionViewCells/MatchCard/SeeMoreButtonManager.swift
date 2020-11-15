//
//  SeeMoreManager.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 12/11/20.
//

import UIKit
class SeeMoreButtonManager {
    var labels: [UILabel] = []
    var seeMoreAction: (()->())!
    
    func manageSeeMoreButtons() {
        let baseTag = 9090
        
        for i in 0..<labels.count {
            let buttonTag = baseTag+i
            let label = labels[i]
            if let uiview = label.superview?.superview as? UIControl,
               let contentStack = uiview.subviews.first{
                if label.isTruncated {
                    addAndConfigButton(genSeeMoreButton(tag: buttonTag), uiview, contentStack, tag: buttonTag)
                }else {
                    if let seeMoreButton = contentStack.viewWithTag(buttonTag) {
                        seeMoreButton.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    private func addAndConfigButton(_ button: UIButton, _ uiview: UIControl, _ contentStack: UIView, tag: Int) {
        contentStack.isUserInteractionEnabled = false
        
        uiview.addSubview(button)
        uiview.isUserInteractionEnabled = true
        uiview.addAction(UIAction(handler: {_ in
            self.seeMoreAction()
        }), for: .touchUpInside)
        
        button.tag = tag
        button.trailingAnchor.constraint(equalTo: uiview.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: uiview.widthAnchor, multiplier: 0.2).isActive = true
        button.lastBaselineAnchor.constraint(equalTo: contentStack.lastBaselineAnchor).isActive = true
        button.isUserInteractionEnabled = false
        button.isAccessibilityElement = false
        
        
    }
    
    func addOrRemoveButton() {
        manageSeeMoreButtons()
    }
    
    private func genSeeMoreButton(tag: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.setDynamicType(textStyle: .subheadline)
        btn.setTitle("mais", for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.contentHorizontalAlignment = .right
        btn.isEnabled = true
        btn.setBackgroundImage(UIImage(named: "seeMoreButtonBackgroundGradient"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    
    init(labels: [UILabel] = []) {
        self.labels = labels
    }
}
