//
//  ShowProfileTableViewCell.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 15/10/20.
//

import UIKit

class ShowProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var showProjectOrProfile: UILabel!
    @IBOutlet weak var showSwitchControll: UISwitch!
    @IBOutlet weak var additionalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
