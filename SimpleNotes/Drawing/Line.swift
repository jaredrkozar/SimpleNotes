//
//  Line.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public struct Line: Equatable {
    var color: UIColor
    var width: Double
    var opacity: Double
    var blendMode: CGBlendMode
    var path: UIBezierPath
    var type: DrawingType
    var fillColor: UIColor?
    var strokeType: StrokeTypes?
    
    mutating func updateOpacity() {
        self.opacity = 0.5
    }
}


enum DrawingType {
    case drawing
    case text
}
