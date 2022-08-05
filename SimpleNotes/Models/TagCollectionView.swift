//
//  TagCollectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 8/3/22.
//

import UIKit

class TagView: UIView {
    
    var xPosition: CGFloat = 5.0
    var yPosition: CGFloat = 5.0
    
    var tags = ["Ddddssllsls", "HELLO", "HELLO", "HELLO", "HELLO"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        for tag in tags {
            let newTagChip = TagChip()
            let width = tag.widthOfString()
            newTagChip.frame = CGRect(x: xPosition, y: yPosition, width: width.width + 10, height: width.height + 10)
            newTagChip.backgroundColor = .red
            newTagChip.tagName = tag
            self.addSubview(newTagChip)
            xPosition = xPosition + width.width + 10 + 5
            print(self.bounds.maxX)
            if self.bounds.maxX < xPosition {
                yPosition = yPosition + width.height + 10
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
