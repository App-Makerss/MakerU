//
//  TextViewTableViewCell.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 15/10/20.
//

import UIKit

protocol TextViewTableViewCellDelegate: class{
    func textDidChanged(_ text: String)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: TextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TextViewTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textDidChanged(textView.text)
    }
}
