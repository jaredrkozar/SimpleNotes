//
//  Brush.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public protocol Tool {
    var width: Double { get set }
    var color: UIColor { get set }
    var opacity: Double { get set }
    var blendMode: CGBlendMode { get set }
    var strokeType: StrokeTypes { get set }
    var drawingView: DrawingView? { get }
    
    func moved(currentPath: UIBezierPath, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> UIBezierPath?
}
