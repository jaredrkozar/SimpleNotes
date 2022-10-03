//
//  Pen.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public class PenTool: Tool {
    public var width: Double
    
    public var color: UIColor
    
    public var opacity: Double
    
    public var blendMode: CGBlendMode
    
    public var strokeType: StrokeTypes
    
    init() {
        self.width = 1.0
        self.color = .red
        self.opacity = 1.0
        self.blendMode = .normal
        self.strokeType = .normal
    }
    
    init(width: Double, color: UIColor, opacity: Double, blendMode: CGBlendMode, strokeType: StrokeTypes) {
        self.width = width
        self.blendMode = blendMode
        self.opacity = opacity
        self.color = color
        self.strokeType = .normal
    }
    
    func moved(currentPath: UIBezierPath, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> UIBezierPath? {
        
        currentPath.move(to: midpoint1)
        currentPath.addQuadCurve(to: midpoint2, controlPoint:previousPoint)
        return currentPath
    }
}
