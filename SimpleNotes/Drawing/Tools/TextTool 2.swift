//
//  TextTool.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/1/22.
//

import UIKit

class TextTool: Tool {
    var strokeType: StrokeTypes = .normal
    
    var width: Double = 0.0
    
    var color: UIColor = .clear
    
    var opacity: Double = 1.0
    
    var blendMode: CGBlendMode = .clear
    
    func moved(currentPath: Line, previousPoint: CGPoint, midpoint1: CGPoint, midpoint2: CGPoint) -> Line? {
        return nil
    }
    
    func moved(currentPath: Line) -> Line {
        return currentPath
    }
    
    var drawingView: DrawingView?
    
    func tappedScreen(sender: UITapGestureRecognizer) {
        if drawingView?.canCreateTextBox == true {
            drawingView!.insertTextBox(frame: CGRect(x: sender.location(in: drawingView).x, y: sender.location(in: drawingView).y, width: 100, height: 100))
        }
    }
}
