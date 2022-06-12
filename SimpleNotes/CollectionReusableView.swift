//
//  CollectionReusableView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/28/22.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    @IBOutlet var collectionViewHeader: UILabel!
    
    static let identifier = "reusableCollectionView"
    
    static func nib() -> UINib {
        return UINib(nibName: "IconCollectionReusableView", bundle: nil)
    }
    
    public let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.gray
        
        return label
    }()
    
    public func configure() {
        backgroundColor = .clear
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
}
