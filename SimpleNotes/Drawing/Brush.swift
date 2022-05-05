//
//  Brush.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/4/22.
//

import UIKit

public class Brush {
    var color: UIColor!
    var width: Double!
    var opacity: Double!
    var blendMode: CGBlendMode!
    var strokeType: StrokeTypes!
    var toolType: Tools!
    
    init() {
        //emeptu initializer
    }
    
    init(color: UIColor, width: Double, strokeType: StrokeTypes, toolType: Tools) {
        //defines pen and highlighter
        self.color = color
        self.width = width
        
        self.blendMode = .normal
        self.strokeType = strokeType
        
        if toolType == .pen {
            self.opacity = 1.0
        } else {
            self.opacity = 0.6
        }
    }

    init(width: Double, toolType: Tools) {
        //defines eraser and lasso
        
        self.opacity = 1.0
        
        if toolType == .eraser {
            self.color = UIColor.clear
            self.width = width
            self.blendMode = .clear
            self.strokeType = .normal
        } else {
            self.color = UIColor.systemBlue
            self.width = 5.0
            self.blendMode = .normal
            self.strokeType = .dashed
        }
    }
}
