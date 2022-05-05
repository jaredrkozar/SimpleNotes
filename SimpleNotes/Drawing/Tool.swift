//
//  Brush.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

public protocol Tool {
    var drawingView: DrawingView? { get }
    
    func moved(currentPath: Line, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> Line?
}
