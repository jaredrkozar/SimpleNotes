//
//  DetailCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailImageView.layer.cornerRadius = 10.0
        
        detailImageView.contentMode = .center
    }

}
