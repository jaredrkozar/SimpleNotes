//
//  Pen.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

class PenTool: Tool {
    
    var drawingView: DrawingView?
    
    func moved(currentPath: Line, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> Line? {
        
        currentPath.path.move(to: midpoint1)
        currentPath.path.addQuadCurve(to: midpoint2, controlPoint:previousPoint)
        return currentPath
    }
}
