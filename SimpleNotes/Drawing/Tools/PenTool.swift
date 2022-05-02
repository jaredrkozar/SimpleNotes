//
//  Pen.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

class PenTool: Brush {
    var drawingView: DrawingView?
    
    var color: UIColor = .red
    
    var width: Double = 5.0
    
    var opacity: Double = 1.0
    
    var blendMode: CGBlendMode = .normal
    
    func moved(currentPath: Line, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> Line? {
        
        currentPath.path.move(to: midpoint1)
        currentPath.path.addQuadCurve(to: midpoint2, controlPoint:previousPoint)
        return currentPath
    }
}
