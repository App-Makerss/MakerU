//
//  MatchCardCollectionViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 14/10/20.
//

import UIKit

class MatchCardCollectionViewCell: UICollectionViewCell {

    let headerHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal

        return view
    }()

    let cardTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title1)
        title.text = "Realidade aumentada para inclusão"
        return title
    }()

    let cardSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.text = "Tecnologia"
        return subtitle
    }()

    let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.setTitleColor(.label, for: .normal)
        return btn
    }()

}
