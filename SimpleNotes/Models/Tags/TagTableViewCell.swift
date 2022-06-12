//
//  TagTableViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    @IBOutlet var tagImage: UIImageView!
    
    @IBOutlet var tagName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
