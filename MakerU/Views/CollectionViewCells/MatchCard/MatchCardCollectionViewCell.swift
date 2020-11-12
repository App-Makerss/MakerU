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
    
    // MARK: - Attributes
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
            setupSwipeUp()
        }
    }
    
    // MARK: - delegates
    var delegate: MatchCardCollectionViewCellDelegate?
    
    // MARK: - Outlets
    var containerview: UIView? = nil
    private var cardView: CardView? = nil

    // MARK: - Inner outlet outlets
    var cardImageView: UIImageView?{cardView?.imageView}
    var cardTitle: UILabel?{cardView?.title}
    var cardSubtitle: UILabel?{cardView?.subtitle}
    var cardFirstSessionTitle: UILabel?{cardView?.firstSectionTitle}
    var cardFirstSessionDescription: UILabel?{cardView?.firstSectionDescription}
    var cardSecondSessionTitle: UILabel?{cardView?.secondSectionTitle}
    var cardSecondSessionDescription: UILabel?{cardView?.secondSectionDescription}
    
    
    // MARK: - setups
    private func setupSwipeUp(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 1
        containerview?.isUserInteractionEnabled = true
        containerview?.addGestureRecognizer(gesture)
    }
    
    // MARK: - objc funcs
    @objc func collaborateButtonTap() {
        delegate?.collaborateButtonTapped(self)
    }
    
    @objc func seeMoreButtonTap() {
        delegate?.seeMoreButtonButtonTapped(self)
    }
    
    @objc func swipeUp(){
        delegate?.showCardSwiped(self)
    }
    
    // MARK: - trait change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        cardView?.layoutSubviews()

    }
}
