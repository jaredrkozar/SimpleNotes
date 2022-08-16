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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .clear
    }
    
    func addTags(tags: [String]) {
        print(tags)
        for tag in tags {
            let newTagChip = TagChip()
            let width = tag.widthOfString()
            newTagChip.backgroundColor = .red
            newTagChip.tagName = tag
            newTagChip.frame = CGRect(x: xPosition, y: yPosition, width: width.width + 10, height: width.height + 10)
            
            if self.frame.width < newTagChip.frame.maxX {
                yPosition = yPosition + width.height + 15
                xPosition = 5.0
            } else {
                xPosition = xPosition + width.width + 10 + 5
                self.addSubview(newTagChip)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
