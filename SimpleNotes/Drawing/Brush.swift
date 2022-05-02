//
//  Brush.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public protocol Brush {
    var color: UIColor { get set }
    var width: Double { get set }
    var opacity: Double { get set }
    var blendMode: CGBlendMode { get set }
    var drawingView: DrawingView? { get }
    
    func moved(currentPath: Line, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> Line?
}
