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
    var path: UIBezierPath
    var type: DrawingType
    var strokeType: StrokeTypes?
}


enum DrawingType {
<<<<<<< HEAD
    case shape
=======
>>>>>>> ios-16
    case drawing
    case text
}
