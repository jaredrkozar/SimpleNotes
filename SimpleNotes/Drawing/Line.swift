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
}


enum DrawingType {
    case shape
    case drawing
}

public enum Shapes {
    case circle
    case rect
    case straightline
}

