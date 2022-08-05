//
//  CustomTextBox.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

class CustomTextBox: UITextView, UIGestureRecognizerDelegate, ObjectView {
    var resizingHandles: [UIButton]
    
    
    var upperLeftDragHandle = ResizableButton()
    var upperRightDragHandle = ResizableButton()
    var bottomLeftDragHandle = ResizableButton()
    var bottomRightDragHandle = ResizableButton()
    
    private var drawingView: DrawingView?
    
    var moveIconImage: UIImageView = UIImageView(image: UIImage(named: "moveIcon"))
    
    var isResizing: Bool
    
    func isCurrentView() {
        self.layer.borderColor = UIColor(hex: UserDefaults.standard.string(forKey: "tintColor")!)?.cgColor ?? UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2.0
    }
    
    func isNotCurrentView() {
        for handle in resizingHandles {
            handle.isHidden = true
        }
        
        self.isResizing = false
        self.isMoving = false
        self.layer.borderColor = nil
        self.layer.borderWidth = 0.0
    }
    
    var isMoving: Bool = false
    var start = CGPoint.zero
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.isResizing = false
        self.resizingHandles = []
        super.init(frame: frame, textContainer: textContainer)
        self.frame = frame
        self.isEditable = true
        self.isUserInteractionEnabled = true
        self.layer.borderColor = UIColor(hex: UserDefaults.standard.string(forKey: "tintColor")!)?.cgColor ?? UIColor.systemBlue.cgColor
        self.textColor = UIColor.label
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.clear
   
        self.addSubview(moveIconImage)
        moveIconImage.isHidden = true
    
        upperLeftDragHandle.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 18, height: 18)
        upperLeftDragHandle.center = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        upperLeftDragHandle.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]

        upperRightDragHandle.frame = CGRect(x: self.bounds.maxX, y: self.bounds.minY, width: 18, height: 18)
        upperRightDragHandle.center = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        upperRightDragHandle.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
 
        bottomLeftDragHandle.bounds = CGRect(x: self.bounds.minX, y: self.bounds.maxY, width: 18, height: 18)
        bottomLeftDragHandle.center = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        bottomLeftDragHandle.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
                                                  
        bottomRightDragHandle.frame = CGRect(x: self.bounds.maxX, y: self.bounds.maxY, width: 18, height: 18)
        bottomRightDragHandle.center = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
        bottomRightDragHandle.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        
        self.clipsToBounds = false
        addSubview(upperLeftDragHandle)
        addSubview(upperRightDragHandle)
        addSubview(bottomLeftDragHandle)
        addSubview(bottomRightDragHandle)
        
        resizingHandles.append(contentsOf: [upperLeftDragHandle, upperRightDragHandle, bottomLeftDragHandle, bottomRightDragHandle])
      
        let upperLeftButtonTouched = UIPanGestureRecognizer(target: self, action: #selector(self.resizeUpperLeft(_:)))
        upperLeftButtonTouched.delegate = self
        upperLeftDragHandle.addGestureRecognizer(upperLeftButtonTouched)
        
        let bottomLeftButtonTouched = UIPanGestureRecognizer(target: self, action: #selector(self.resizeButtomLeft(_:)))
        bottomLeftButtonTouched.delegate = self
        bottomLeftDragHandle.addGestureRecognizer(bottomLeftButtonTouched)
        
        let bottomRightButtonTouched = UIPanGestureRecognizer(target: self, action: #selector(self.resizeBottomRight(_:)))
        bottomRightButtonTouched.delegate = self
        bottomRightDragHandle.addGestureRecognizer(bottomRightButtonTouched)
        
        let upperRightButtonTouched = UIPanGestureRecognizer(target: self, action: #selector(self.resizeUpperRight(_:)))
        upperRightButtonTouched.delegate = self
        upperRightDragHandle.addGestureRecognizer(upperRightButtonTouched)
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(self.moveTextBox(_:)))
        move.delegate = self
        self.addGestureRecognizer(move)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var canBecomeFirstResponder: Bool{
        return true
    }
    
    @objc func resizeUpperLeft(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .ended, .cancelled:
                start = CGPoint.zero
        case .changed:
            if isResizing == true {
                HelperFunctions.resizeUpperLeft(view: self, translation: sender.translation(in: self), start: start)
                start = sender.translation(in: self)
            }
        default:
            return
        }
    }
    
    @objc func resizeUpperRight(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
            case .ended, .cancelled:
                start = CGPoint.zero
        case .changed:
            if isResizing == true {
                HelperFunctions.resizeUpperRight(view: self, translation: sender.translation(in: self), start: start)
                start = sender.translation(in: self)
            }
        default:
            return
        }
    }
    
    @objc func resizeButtomLeft(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .ended, .cancelled:
            start = CGPoint.zero
        case .changed:
            if isResizing == true {
                HelperFunctions.resizeLowerLeft(view: self, translation: sender.translation(in: self), start: start)
                start = sender.translation(in: self)
            }
        default:
            return
        }
    }
    
    @objc func resizeBottomRight(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .ended, .cancelled:
            start = CGPoint.zero
        case .changed:
            if isResizing == true {
                HelperFunctions.resizeLowerRight(view: self, translation: sender.translation(in: self), start: start)
                start = sender.translation(in: self)
            }
        default:
            return
        }
    }
    
    @objc func moveTextBox(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended, .cancelled:
            start = CGPoint.zero
        case .changed:
            if self.isMoving == true {
                self.moveBy(x: sender.translation(in: self).x - start.x, y: sender.translation(in: self).y - start.y)
                start = sender.translation(in: self)
            }
        default:
            return
        }
    }
    
    func makeBold(text: String, range: NSRange) -> NSAttributedString {
 
        let attributes: [NSAttributedString.Key: Any] = [
           
            .font:  UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.label,
        ]
         
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func makeItalics(text: String, range: NSRange) -> NSAttributedString {
 
        let attributes: [NSAttributedString.Key: Any] = [
           
            .font:  UIFont.italicSystemFont(ofSize: 12),
            .foregroundColor: UIColor.label,
        ]
         
        return NSAttributedString(string: text, attributes: attributes)
    }
    
}

enum attributes {
    case bold
    case italics
    case underline
}
