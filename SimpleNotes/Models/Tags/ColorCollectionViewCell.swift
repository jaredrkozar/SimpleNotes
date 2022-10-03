//
//  ColorCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/28/22.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    static let identifier = "colorCell"
    var icon: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.image = UIImage(systemName: "pin")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.tintColor = .green
        contentView.addSubview(icon)
        
    }
}
