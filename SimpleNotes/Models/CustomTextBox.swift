//
//  CustomTextBox.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/28/22.
//

import UIKit

class CustomTextBox: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.frame = frame
        self.isEditable = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        self.layer.borderWidth = 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
