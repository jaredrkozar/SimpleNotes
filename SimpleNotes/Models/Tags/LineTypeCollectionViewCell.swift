//
//  LineTypeCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/13/22.
//

import UIKit

class LineTypeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var lineImage: UIImageView!
    @IBOutlet var lineName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lineName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }

}
