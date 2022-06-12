//
//  CustomSelectionView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/1/22.
//

import UIKit

class CustomSelectionView: UIView, UIGestureRecognizerDelegate, ObjectView {
    var resizingHandles: [UIButton]
    
    
    private var drawingView: DrawingView?
    var start = CGPoint.zero
    
    var moveIconImage: UIImageView = UIImageView(image: UIImage(named: "moveIcon"))
    
    var isMoving: Bool
    
    var isResizing: Bool
    
    var selectionLayer = CAShapeLayer()
    var selectedLine: Line?
    
    init(line: Line) {
        self.isMoving = false
        self.isResizing = false
        self.resizingHandles = []
        super.init(frame: line.path.bounds)
        
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.isHidden = true
        selectedLine = line
        self.isUserInteractionEnabled = true

        selectionLayer.strokeColor = UIColor.systemBlue.cgColor

        selectionLayer.frame = self.bounds
        selectionLayer.path = UIBezierPath(rect: self.bounds).cgPath

        self.layer.addSublayer(selectionLayer)
        
        let swipeLine = UIPanGestureRecognizer(target: self, action: #selector(self.swipeLine(_:)))
        swipeLine.delegate = self
        self.addGestureRecognizer(swipeLine)
        
    }
    
    @objc func swipeLine(_ sender: UIPanGestureRecognizer) {
        if self.isMoving == true {
            self.selectedLine?.path.apply(CGAffineTransform(translationX:  sender.translation(in: self).x - self.start.x, y:  sender.translation(in: self).y - self.start.y))
                
            self.start = sender.translation(in: self)
            drawingView?.setNeedsDisplay()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCurrentView() {
        selectionLayer.strokeColor = UIColor.systemBlue.cgColor
        selectionLayer.lineWidth = 3.0
        selectionLayer.lineDashPattern = [3.0, 4.0]
    }
    
    func isNotCurrentView() {
        self.isResizing = false
        self.isMoving = false
        selectionLayer.strokeColor = UIColor.clear.cgColor

        selectionLayer.fillColor = UIColor.clear.cgColor
        selectionLayer.lineWidth = 0.0
        selectionLayer.lineDashPattern = []
    }

    open override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
}
