//
//  TagCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 8/3/22.
//

import UIKit

class TagChip: UIView {

    var label = UILabel(frame: .zero)
    
    var tagName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        label.textColor = .white
        label.text = tagName
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        
        let width = tagName?.widthOfString()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        self.addSubview(label)
        
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 5.0
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: label.bounds.width),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = tintColor
    }
}
