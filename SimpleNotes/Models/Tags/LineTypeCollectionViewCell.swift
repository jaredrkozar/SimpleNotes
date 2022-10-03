//
//  LineTypeCollectionViewCell.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/13/22.
//

import UIKit

class LineTypeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LineTypeCollectionViewCell"

    var lineType: StrokeTypes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.bounds.minX, y: contentView.bounds.midY))
        path.addLine(to: CGPoint(x: contentView.bounds.maxX, y: contentView.bounds.midY))
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemCyan.cgColor
        shapeLayer.lineWidth = 3.0
        
        self.layer.addSublayer(shapeLayer)
    }

}
