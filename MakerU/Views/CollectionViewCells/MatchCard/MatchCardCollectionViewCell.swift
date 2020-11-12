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

class MatchCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)
    
    var delegate: MatchCardCollectionViewCellDelegate?
    
    let layoutFactory = CardLayoutFactory()
    
    var cardFace: CardFace = .front {
        didSet{
            layoutFactory.makeCardLayout(inView: contentView, cardFace: cardFace, seeMoreAction: {
                self.seeMoreButtonTap()
            }, collaborateAction: {
                self.collaborateButtonTap()
            })
            cardView = viewWithTag(200) as? CardView
            containerview = cardView?.superview
        }
    }
    
    public func showSwipeUp(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 1
        containerview?.isUserInteractionEnabled = true
        containerview?.addGestureRecognizer(gesture)
    }
    
    @objc func swipeUp(){
        delegate?.showCardSwiped(self)
    }
    var containerview: UIView? = nil
    var cardView: CardView? = nil

    var cardImageView: UIImageView?{cardView?.imageView}
    var cardTitle: UILabel?{cardView?.title}
    var cardSubtitle: UILabel?{cardView?.subtitle}
    var cardFirstSessionTitle: UILabel?{cardView?.firstSectionTitle}
    var cardFirstSessionDescription: UILabel?{cardView?.firstSectionDescription}
    var cardSecondSessionTitle: UILabel?{cardView?.secondSectionTitle}
    var cardSecondSessionDescription: UILabel?{cardView?.secondSectionDescription}
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        TODO: botoes ver mais podem ser gerenciados por um terceiro obj (falta fazer os botões funcionar)
        showSwipeUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func collaborateButtonTap() {
        delegate?.collaborateButtonTapped(self)
    }
    
    @objc func seeMoreButtonTap() {
        delegate?.seeMoreButtonButtonTapped(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        cardView?.layoutSubviews()

    }
}
