//
//  ResizableButton.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

class ResizableButton: UIButton {

    var drawingView: DrawingView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        print(drawingView?.objectTintColor)
        self.layer.backgroundColor = tintColor.cgColor
        self.layer.cornerRadius = 5

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = tintColor
    }
    
}

