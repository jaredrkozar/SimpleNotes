//
//  DrawingView.swift
//  SwiftyDrawingKit
//
//  Created by JaredKozar on 1/28/22.
//

import UIKit

@objc public protocol DrawingViewDelegate: AnyObject {
    
    func currentTextBoxColor() -> UIColor
}

class DrawingView: UIView, UIGestureRecognizerDelegate, UITextViewDelegate, UIScrollViewDelegate {

    public weak var delegate: DrawingViewDelegate?
    
    public var objectTintColor: UIColor?
    
    public var tool: Tools?
    
    public var selectedTool: Tool? {
        if self.tool == .pen {
            return  currentPen ?? PenTool(width: 4.0, color: UIColor.systemBlue, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        } else if self.tool == .highlighter {
            return currentHighlighter ?? PenTool(width: 4.0, color: UIColor.systemYellow, opacity: 0.8, blendMode: .normal, strokeType: .normal)
        } else if self.tool == .text {
            return TextTool()
        } else {
            return nil
        }
    }
    
    public var currentPen: PenTool?
    public var currentHighlighter: PenTool?
    
    private var keyboardIsOpen: Bool = false
    private var scrollView = UIScrollView()
    
    public var canCreateTextBox: Bool = true
    private var isSelectingLine: Bool = false
    
    private var shape: Shapes?
    
    public var selectedShape: Shapes? {
        get {
            return shape
        }
        set {
            tool = nil
            self.shape = newValue
        }
    }
    
    var menu = UIMenuController.shared
    var lines = [Line]()
    var textBoxes = [CustomTextBox]()
    var images = [CustomImageView]()
    var currentView: ObjectView?
    
    var currentPoint: CGPoint?
    var previousPoint: CGPoint?
    var previousPreviousPoint: CGPoint?
    var shapeFirstPoint: CGPoint?
    
    var shapeFillColor: UIColor = .clear
    var shapeStrokeColor: UIColor = .red
    var shapeWidth: Double?
    
    private let forceSensitivity: CGFloat = 9.0
                    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(_:)))
          self.addGestureRecognizer(tapGesture)
          self.layer.drawsAsynchronously = true
        print(self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    open override func draw(_ rect: CGRect) {

        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for line in lines {
            
            context.setBlendMode(line.blendMode )
            context.setAlpha(line.opacity)
            
            switch line.strokeType {
                case .dotted:
                line.path.setLineDash([1, 30.0], count: 2, phase: 0.0)
                line.path.lineCapStyle = .round
                case .dashed:
                line.path.setLineDash([1, 30.0], count: 2, phase: 0.0)
                line.path.lineCapStyle = .square
            case .none, .normal:
                line.path.lineCapStyle = .round
            }
            
            switch line.type {
            case .drawing:
                line.path.lineWidth = line.width
                line.color.setStroke()
                line.path.stroke()
            case .text:
                line.path.lineWidth = line.width
                shapeStrokeColor.setStroke()
                shapeFillColor.setFill()
                line.path.fill()
            case .shape:
                line.path.lineWidth = line.width
                shapeStrokeColor.setStroke()
                shapeFillColor.setFill()
                line.path.fill()
            }
        }
    }
    
    @objc func textBoxTapped(_ sender: UITapGestureRecognizer) {
        currentView?.isNotCurrentView()
       let editItem = UIMenuItem(title: "Edit", action: #selector(self.editTextBox))
       let backgroundColorItem = UIMenuItem(title: "Background Color", action: #selector(self.changeBGColor))
        let moveTextboxItem = UIMenuItem(title: "Move", action: #selector(self.moveTextbox))
        let resizeTextboxItem = UIMenuItem(title: "Resize", action: #selector(self.resizeTextbox))
        let deleteTextboxItem = UIMenuItem(title: "Delete", action: #selector(self.deleteTextBox))
        currentView?.isNotCurrentView()
    
        currentView =  sender.view as? ObjectView
        
        currentView?.isCurrentView()
        
        menu.menuItems = [editItem, backgroundColorItem, moveTextboxItem, resizeTextboxItem, deleteTextboxItem]
        
        if keyboardIsOpen == true {
            dismissKeyboard()
        } else {
            menu.showMenu(from: currentView as! UIView, rect: CGRect(x: 1, y: 1, width: 100, height: 100))
            print(menu.isMenuVisible)
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        currentView?.isNotCurrentView()
         let moveTextboxItem = UIMenuItem(title: "Move", action: #selector(self.moveTextbox))
         let resizeTextboxItem = UIMenuItem(title: "Resize", action: #selector(self.resizeTextbox))
         let deleteTextboxItem = UIMenuItem(title: "Delete", action: #selector(self.deleteTextBox))
     
        currentView = sender.view as! ObjectView
         menu.menuItems = [moveTextboxItem, resizeTextboxItem, deleteTextboxItem]
         
        menu.showMenu(from: currentView as! UIView, rect: CGRect(x: 1, y: 1, width: 100, height: 100))
    }
    
    open override var canBecomeFirstResponder: Bool{
        return true
    }
    
    @objc func resizeTextbox() {
        canCreateTextBox = false
        currentView?.isResizing = true
        if let textbox = currentView as? CustomTextBox {
            for handle in textbox.resizingHandles {
                handle.isHidden = false
            }
        }
    }
    
    @objc func editTextBox(){
        canCreateTextBox = false
        if let new = currentView as? CustomTextBox {
            new.becomeFirstResponder()
        }
    }
    
    @objc func changeBGColor(){
        if let new = currentView as? CustomTextBox {
            new.backgroundColor = delegate?.currentTextBoxColor()
        }
    }
    
    @objc func moveTextbox() {
        canCreateTextBox = false
        currentView?.moveIconImage.isHidden = false
        currentView?.moveIconImage.frame = CGRect(x: 4, y: 0, width: (currentView as! UIView).bounds.width / 4, height: (currentView as! UIView).bounds.height / 4)
        currentView?.moveIconImage.center = (currentView as! UIView).center
        currentView?.isMoving = true
    }
    
    @objc func deleteTextBox(){
        if let textbox = currentView as? CustomTextBox {
            textbox.removeFromSuperview()
            textbox.isNotCurrentView()
            textBoxes.remove(at: textBoxes.firstIndex(of: textbox)!)
        } else if let image = currentView as? CustomImageView {
            image.isNotCurrentView()
            image.removeFromSuperview()
        } else if let stroke = currentView as? CustomSelectionView {
            lines.remove(at: lines.firstIndex(where: {stroke.selectedLine == $0})!)
            currentView?.isNotCurrentView()
            setNeedsDisplay()
        }
    }
    
    @objc func tappedScreen(_ sender: UITapGestureRecognizer) {
        print("dkdkddkdkkdkdkdkdkdkdTAP")
        print(keyboardIsOpen)
        if currentView?.isMoving == true || currentView?.isResizing == true || isSelectingLine == true {
            currentView?.moveIconImage.isHidden = true
            canCreateTextBox = true
            isSelectingLine = false
            currentView?.isNotCurrentView()
        } else if menu.isMenuVisible == true {
            currentView?.isNotCurrentView()
            menu.hideMenu()
        } else if keyboardIsOpen == true {
                dismissKeyboard()
        } else {
            if tool == .text {
               tappedScreen(sender)
            
            } else if tool == .eraser {
                let inLines = self.returnLines(point: sender.location(in: self))
    //            lines.removeAll(where: {inLines.contains($0)})
            } else if tool == .lasso {
              
                let selectedLine = self.returnLines(point: sender.location(in: self))
                if selectedLine != nil {
                    let selectionView = CustomSelectionView(line: selectedLine!)
                    selectionView.isUserInteractionEnabled = true
                    self.addSubview(selectionView)
                    selectionView.becomeFirstResponder()
                    isSelectingLine = true
                    selectionView.selectedLine = selectedLine
                    currentView = selectionView
                    let moveTextboxItem = UIMenuItem(title: "Move", action: #selector(self.moveTextbox))
                    let resizeTextboxItem = UIMenuItem(title: "Resize", action: #selector(self.resizeTextbox))
                    let deleteTextboxItem = UIMenuItem(title: "Delete", action: #selector(self.deleteTextBox))
                
                    menu.menuItems = [moveTextboxItem, resizeTextboxItem, deleteTextboxItem]
                    
                    menu.showMenu(from: currentView as! UIView, rect: CGRect(x: 1, y: 1, width: 100, height: 100))
                }
            }
        }
    }
        
    private func returnLines(point: CGPoint) -> Line? {
        var checkLines: Line?
                
        let linesatpoint = lines.filter({$0.path.contains(point)})
            
        guard linesatpoint.first != nil else{
            
            return nil
           }
        
        return linesatpoint.first
    }
    
    func insertTextBox(frame: CGRect) {
        let textbox = CustomTextBox(frame: frame, textContainer: nil)

        textbox.becomeFirstResponder()
        self.addSubview(textbox)
        textbox.isCurrentView()
        textbox.isUserInteractionEnabled = true
        currentView = textbox
        canCreateTextBox = false
        let textBoxTapped = UITapGestureRecognizer(target: self, action: #selector(self.textBoxTapped(_:)))
        textbox.addGestureRecognizer(textBoxTapped)
        textBoxes.append(textbox)
    }
    
        
    public func insertImage(frame: CGRect?, image: UIImage) {
        let newImage = CustomImageView(frame: frame!, image: image)
        currentView = newImage
        newImage.becomeFirstResponder()
        newImage.isUserInteractionEnabled = true
        
        let textBoxTapped = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        print(textBoxTapped)
        newImage.addGestureRecognizer(textBoxTapped)
        
        self.addSubview(newImage)
        
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {return}
        currentPoint = touch.location(in: self)
        setTouchPoints(touch)
        
        shapeFirstPoint = touch.location(in: self)
        
        lines.append(Line(color: (selectedTool?.color)!, width: (selectedTool?.width)! , opacity: (selectedTool?.opacity)!, blendMode: selectedTool?.blendMode ?? .normal, path: UIBezierPath(), type: .drawing, strokeType: selectedTool?.strokeType))
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("DLDLDL")
        guard let touch = touches.first else { return }
        getTouchPoints(touch)
        
        if tool != .text {
            if var currentPath = lines.popLast() {
                currentPath.path = (selectedTool?.moved(currentPath: currentPath.path, previousPoint:  CGPoint(x: previousPoint!.x, y: previousPoint!.y), midpoint1: CGPoint(x: getMidPoints().0.x, y: getMidPoints().0.y), midpoint2: CGPoint(x: getMidPoints().1.x, y: getMidPoints().1.y))!)!
                lines.append(currentPath)
                print(lines.count)
                setNeedsDisplay()
           }
        } else {
            if canCreateTextBox == true {
                if !lines.isEmpty {
                    lines.removeLast()
                    setNeedsDisplay()
                }
                
                var newLine = Line(color: UIColor.systemBlue, width: 2.0, opacity: 1.0, blendMode: .normal, path: UIBezierPath(), type: .drawing, fillColor: UIColor.brown)
                print(selectedTool)
                newLine.path = (selectedTool?.moved(currentPath: newLine.path, previousPoint: shapeFirstPoint!, midpoint1: currentPoint!, midpoint2: currentPoint!)!)!
                lines.append(newLine)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentView?.isMoving == true || currentView?.isResizing  == true {
            currentView?.start = CGPoint.zero
        }
        if tool == .eraser {
            lines.removeLast()
        } else if tool == .text {
            if canCreateTextBox == true {
                lines.removeLast()
                setNeedsDisplay()
                insertTextBox(frame: CGRect(x: shapeFirstPoint!.x, y: shapeFirstPoint!.y, width: currentPoint!.x - shapeFirstPoint!.x, height: currentPoint!.y - shapeFirstPoint!.y))
            }
        }
    }
    
    private func setTouchPoints(_ touch: UITouch) {
        previousPoint = touch.previousLocation(in: self)
        previousPreviousPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
    }
    
    private func getTouchPoints(_ touch: UITouch) {
        previousPreviousPoint = previousPoint
        previousPoint = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
    }
    
    public func getMidPoints() -> (CGPoint,  CGPoint) {
        let mid1 : CGPoint = findMidpoint(point1: previousPoint!, point2: previousPreviousPoint!)
        let mid2 : CGPoint = findMidpoint(point1: currentPoint!, point2: previousPoint!)
        return (mid1, mid2)
    }
    
    public func findMidpoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x + point2.x) * 0.5, y: (point1.y + point2.y) * 0.5);
    }
    
    @objc func keyboardWillDisappear(){
        keyboardIsOpen = false
    }
    
    @objc func keyboardWillAppear(){
        keyboardIsOpen = true
    }
    
    required public init?(coder aDecoder: NSCoder?) {
        super.init(coder: aDecoder!)
    }
    
    private func addshape(shape: Shapes) -> UIBezierPath {

        var shapePath = UIBezierPath()
        
        switch shape {
            case .rect:
            shapePath = UIBezierPath(rect: CGRect(x: shapeFirstPoint!.x, y: shapeFirstPoint!.y, width: currentPoint!.x - shapeFirstPoint!.x, height: currentPoint!.y - shapeFirstPoint!.y))
        case .circle:
            shapePath = UIBezierPath(arcCenter: shapeFirstPoint!, radius: currentPoint!.x - shapeFirstPoint!.x, startAngle: 0, endAngle: 180, clockwise: true)
        case .straightline:
            shapePath.move(to: shapeFirstPoint!)
            shapePath.addLine(to: currentPoint!)
        }
        return shapePath
    }
    
    
    @objc func dismissKeyboard() {
        currentView?.isNotCurrentView()
        canCreateTextBox = true
        self.endEditing(true)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self
    }
}
