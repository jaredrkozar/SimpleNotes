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
        self.layer.backgroundColor = drawingView?.objectTintColor?.cgColor ?? UIColor.systemBlue.cgColor
        self.layer.cornerRadius = 10

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

