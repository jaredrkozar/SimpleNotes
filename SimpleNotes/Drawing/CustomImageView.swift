//
//  CustomImageView.swift
//  SwiftyDrawingKit
//
//  Created by JaredKozar on 2/14/22.
//

import UIKit

class CustomImageView: UIImageView, UIGestureRecognizerDelegate, ObjectView {
    var resizingHandles: [UIButton]
    
    
    var drawingView: DrawingView?
    var moveIconImage: UIImageView = UIImageView(image: UIImage(named: "moveIcon"))
    

    var isMoving: Bool = false
    var start = CGPoint.zero
    var isResizing: Bool = false
    
    func isCurrentView() {
        self.layer.borderColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))?.cgColor
        self.layer.borderWidth = 2.0
    }
    
    func isNotCurrentView() {
        self.moveIconImage.isHidden = true
        self.isResizing = false
        self.isMoving = false
        self.layer.borderColor = nil
        self.layer.borderWidth = 0.0
    }
    
    init(frame: CGRect, image: UIImage) {
        self.isResizing = false
        self.resizingHandles = []
        super.init(frame: frame)
        self.frame = frame
        self.image = image
        moveIconImage.frame = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 100, height: 100)
        
        self.addSubview(moveIconImage)
        self.moveIconImage.isHidden = true
        
        self.isUserInteractionEnabled = true
        let swipeImage = UIPanGestureRecognizer(target: self, action: #selector(self.swipeImage(_:)))
        swipeImage.delegate = self
        self.addGestureRecognizer(swipeImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var canBecomeFirstResponder: Bool{
        return true
        
    }
    
    @objc func swipeImage(_ sender: UIPanGestureRecognizer) {
        if isMoving == true {
            moveIconImage.isHidden = false
            self.moveBy(x: sender.translation(in: self).x - start.x, y: sender.translation(in: self).y - start.y)
        } else if isResizing == true {
            HelperFunctions.resizeLowerRight(view: self, translation: sender.translation(in: self), start: start)
        }
        
        start = sender.translation(in: self)
    }
}
