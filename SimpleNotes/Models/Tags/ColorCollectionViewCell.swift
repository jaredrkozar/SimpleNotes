//
//  ColorCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/28/22.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    static let identifier = "colorCell"
    var icon = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.backgroundColor = .systemBlue
        icon.tintColor = .systemBlue
        icon.image = UIImage(systemName: "pin")
        contentView.addSubview(icon)
        NSLayoutConstraint.activate([
        icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
        icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
        icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        icon.widthAnchor.constraint(equalToConstant: 40),
        icon.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
