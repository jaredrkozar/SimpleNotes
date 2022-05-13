//
//  ColorCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/28/22.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet var checkmark: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if checkmark != nil {
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            checkmark.isHidden = true
        }
        
    }
    
    func setSelected() {
        if(isSelected == true) {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
    }

}
