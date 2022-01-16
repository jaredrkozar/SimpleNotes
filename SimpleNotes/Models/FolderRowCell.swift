//
//  FolderRowCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/15/22.
//

import UIKit

class FolderRowCell: UITableViewCell {

    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
