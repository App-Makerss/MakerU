//
//  SkillsTableViewCell.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 15/10/20.
//

import UIKit

protocol SkillsTableViewCellDelegate: class{
    func skillsDidChanged(skills: String)
}

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var skillsTextView: UITextView!
    
    weak var delegate: SkillsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        skillsTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SkillsTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.skillsDidChanged(skills: textView.text)
    }
}
