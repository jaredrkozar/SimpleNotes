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
    private var lastLine: Line?
    var insertedStroke: ((_ lineToInsert: Line)->())?
    var deleteStroke: ((_ lineIndexToDelete: Int)->())?
    var insertedImage: ((_ imageToInsert: UIImage, _ imageFrame: CGRect)->())?
    var deleteImage: ((_ imageIndexToDelete: Int)->())?
    var insertedTextbox: ((_ textboxToInsert: CustomTextBox)->())?
    var deleteTextbox: ((_ textboxIndexToDelete: Int)->())?
    
    public var selectedTool: Tool? {
        if self.tool == .pen {
            return  currentPen ?? PenTool(width: 4.0, color: UIColor.systemBlue, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        } else if self.tool == .highlighter {
            return currentHighlighter ?? PenTool(width: 4.0, color: UIColor.systemYellow, opacity: 0.8, blendMode: .normal, strokeType: .normal)
        } else if self.tool == .eraser {
            return PenTool(width: 4.0, color: UIColor.clear, opacity: 1.0, blendMode: .normal, strokeType: .normal)
        } else if self.tool == .lasso {
            return PenTool(width: 4.0, color: UIColor.systemBlue, opacity: 1.0, blendMode: .normal, strokeType: .normal)
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
    
    private var drawingStraightLine: Bool = false
    
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
         
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let press = UILongPressGestureRecognizer(target: self, action: #selector(drawStraightLine(_:)))
        press.cancelsTouchesInView = false
        press.delegate = self
        press.numberOfTouchesRequired = 1
        press.minimumPressDuration = 0.4
        return press
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        tap.numberOfTouchesRequired = 1
        return tap
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isMultipleTouchEnabled = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        self.layer.drawsAsynchronously = true

        self.addGestureRecognizer(longPressGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func drawStraightLine(_ gesture: UILongPressGestureRecognizer) {
        drawingStraightLine = true
    }
    
    open override func draw(_ rect: CGRect) {

        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for line in lines {

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
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        currentView?.isNotCurrentView()
         let moveTextboxItem = UIMenuItem(title: "Move", action: #selector(self.moveTextbox))
         let resizeTextboxItem = UIMenuItem(title: "Resize", action: #selector(self.resizeTextbox))
         let deleteTextboxItem = UIMenuItem(title: "Delete", action: #selector(self.deleteTextBox))
     
        currentView = sender.view as! ObjectView
        currentView?.isCurrentView()
        
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
                handle.bringSubviewToFront(currentView as! UIView)
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
        let vc = SelectColorPopoverViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        let topmostVC = findViewController()
        
        if currentDevice == .iphone || topmostVC?.traitCollection.horizontalSizeClass == .compact {
            if let picker = navigationController.presentationController as? UISheetPresentationController {
                picker.detents = [.medium()]
                picker.prefersGrabberVisible = true
                picker.preferredCornerRadius = 5.0
            }
        } else if currentDevice == .ipad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
            navigationController.preferredContentSize = CGSize(width: 270, height: 250)
            navigationController.popoverPresentationController?.sourceItem = currentView as? UIView
        } else {
            return
        }
        vc.vcTitle = "Background Color"
        vc.displayTransparent = true
        topmostVC?.present(navigationController, animated: true)
        let textBox = self.currentView as? CustomTextBox
        let originalColor = textBox?.backgroundColor
        
        vc.returnColor = { color in
            
            let textBox = self.currentView as? CustomTextBox
            
            textBox?.backgroundColor = UIColor(hex: color)
        }
        
        undoManager!.registerUndo(withTarget: self) { target in
            textBox?.backgroundColor = originalColor
        }
    }
    
    @objc func moveTextbox() {
        
        if let textbox = currentView as? CustomTextBox {
            let oldframe = textbox.frame

            undoManager!.registerUndo(withTarget: self) { target in
                textbox.frame = oldframe
            }
            
        } else if let image = currentView as? CustomImageView {
            let oldframe = image.frame
            
            undoManager!.registerUndo(withTarget: self) { target in
                image.frame = oldframe
            }
        }
        
        canCreateTextBox = false
        currentView?.moveIconImage.isHidden = false
        currentView?.moveIconImage.center = (currentView as! UIView).center
        currentView?.isMoving = true
    }
    
    @objc func deleteTextBox(){
        if let textbox = currentView as? CustomTextBox {
            textbox.removeFromSuperview()
            textbox.isNotCurrentView()
            textBoxes.remove(at: textBoxes.firstIndex(of: textbox)!)
        } else if let image = currentView as? CustomImageView {
            let firstImageIndex = (images.firstIndex(of: image) ?? images.count)
            
            images.remove(at: firstImageIndex)
            deleteImage?(firstImageIndex)
            image.isNotCurrentView()
            image.removeFromSuperview()
            
        }
    }
    
    @objc func tappedScreen(_ sender: UITapGestureRecognizer) {
   
        if currentView != nil {
            currentView?.moveIconImage.isHidden = true
            canCreateTextBox = true
            isSelectingLine = false
            currentView?.isNotCurrentView()
            dismissKeyboard()
        } else if menu.isMenuVisible == true {
            currentView?.isNotCurrentView()
            dismissKeyboard()
            menu.hideMenu()
        } else if keyboardIsOpen == true {
                dismissKeyboard()
        } else {
            if tool == .text {
                if canCreateTextBox == true {
                    insertTextBox(frame: CGRect(x: sender.location(in: self).x, y: sender.location(in: self).y, width: 100, height: 100))
                   }
            } else if tool == .eraser {
                let inLines = self.returnLines(point: sender.location(in: self))
    //            lines.removeAll(where: {inLines.contains($0)})
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
        
        undoManager!.registerUndo(withTarget: self) { target in
            textbox.removeFromSuperview()
            self.textBoxes.removeLast()
        }
    }
    
    func insertSelectionView(frame: CGRect, selectedLines: [Int]) {
        let selectionView = CustomSelectionView(frame: frame)
        selectionView.selectedLines = selectedLines.map({lines[$0]})
        selectionView.becomeFirstResponder()
        self.addSubview(selectionView)
        selectionView.isCurrentView()
        selectionView.isUserInteractionEnabled = true
        currentView = selectionView
        let selectionTapped = UITapGestureRecognizer(target: self, action: #selector(self.textBoxTapped(_:)))
        selectionView.addGestureRecognizer(selectionTapped)
    }
    
    @objc func selectionTapped(_ sender: UITapGestureRecognizer) {
        print("SelectionTapped")
    }
    
    public func insertImage(frame: CGRect?, image: UIImage) {
        let newImage = CustomImageView(frame: frame!, image: image)
        insertedImage?(image, frame!)
        currentView = newImage
        newImage.becomeFirstResponder()
        newImage.isUserInteractionEnabled = true
        images.append(newImage)
        let textBoxTapped = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
    
        newImage.addGestureRecognizer(textBoxTapped)
        
        self.addSubview(newImage)
        
        undoManager?.registerUndo(withTarget: self) { target in
            newImage.removeFromSuperview()
        }
        
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        guard let touch = touches.first else {return}
        currentPoint = touch.location(in: self)
        setTouchPoints(touch)
        shapeFirstPoint = touch.location(in: self)
        if tool != .scroll && 1 == (event?.allTouches!.count)! {
            lines.append(Line(color: (selectedTool?.color)!, width: (selectedTool?.width)! , opacity: (selectedTool?.opacity)!, path: UIBezierPath(), type: .drawing, strokeType: selectedTool?.strokeType))
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        guard let touch = touches.first else { return }
        getTouchPoints(touch)
        
        if (tool != .scroll && tool != .text) && touches.count == 1 {
            
            if var currentPath = lines.popLast() {
                
                if drawingStraightLine == true {
                    var linePath = UIBezierPath()
                    linePath.move(to: shapeFirstPoint!)
                    linePath.addLine(to: currentPoint!)
                    
                    currentPath.path = linePath
                } else {
                    currentPath.path = (selectedTool?.moved(currentPath: currentPath.path, previousPoint:  CGPoint(x: previousPoint!.x, y: previousPoint!.y), midpoint1: CGPoint(x: getMidPoints().0.x, y: getMidPoints().0.y), midpoint2: CGPoint(x: getMidPoints().1.x, y: getMidPoints().1.y))!)!
                }
                
                if tool == .eraser {
                    if let returnedInt = returnAnnotationIndexAtPoint(point: currentPoint!), returnAnnotationIndexAtPoint(point: currentPoint!) != nil {
                       
                        lines.remove(at: returnedInt)
                    }
                }
                
                lines.append(currentPath)
                setNeedsDisplay()
           }
        } else if tool == .text {
            if canCreateTextBox == true {
                if !lines.isEmpty {
                    lines.removeLast()
                    setNeedsDisplay()
                }
                
                var newLine = Line(color: UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))!, width: 2.0, opacity: 1.0, path: UIBezierPath(), type: .drawing)
                
                newLine.path = (selectedTool?.moved(currentPath: newLine.path, previousPoint: shapeFirstPoint!, midpoint1: currentPoint!, midpoint2: currentPoint!)!)!
                lines.append(newLine)
            }
        }
    }
    
    public func redoLastStroke() {
        undoManager?.redo()
       setNeedsDisplay()
    }
    
    public func undoLastStroke() {
        undoManager?.undo()
       setNeedsDisplay()
        
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawingStraightLine = false
        
        undoManager?.setActionName("Undo Stroke")
        
        if currentView?.isMoving == true || currentView?.isResizing  == true {
            currentView?.start = CGPoint.zero
        }
        
        if tool == .eraser {
            lines.removeLast()
        } else if tool == .text {
            if canCreateTextBox == true {
               
                lines.removeLast()
                setNeedsDisplay()
                
                if (abs(currentPoint!.x - shapeFirstPoint!.x) > 50) && (abs(currentPoint!.y - shapeFirstPoint!.y) > 50) {
                    insertTextBox(frame: CGRect(x: shapeFirstPoint!.x, y: shapeFirstPoint!.y, width: currentPoint!.x - shapeFirstPoint!.x, height: currentPoint!.y - shapeFirstPoint!.y))
                }
            }
        } else if tool == .pen || tool == .highlighter {
            insertedStroke?(lines.last!)
            undoManager!.registerUndo(withTarget: self) { target in
                if self.lines.count > 0 {
                    self.lines.removeLast()
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    func undo() {
        undoManager?.undo()
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
    
    @objc func dismissKeyboard() {
        currentView?.isNotCurrentView()
        canCreateTextBox = true
        self.endEditing(true)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self
    }
    
    private func returnAnnotationIndexAtPoint(point: CGPoint) -> Int? {
        
        let removeLine = lines.filter({checkContains(point: point, path: $0.path, width: $0.width)})
        var intToReturn: Int?
        
        if removeLine.count != 0 {
            intToReturn = lines.firstIndex(of: removeLine.first!)
        }
        return intToReturn ?? nil
    }
    
    private func checkContains(point: CGPoint, path: UIBezierPath, width: Double) -> Bool {
        var hitPath: CGPath?
        hitPath = path.cgPath.copy(strokingWithWidth: width, lineCap: .round, lineJoin: .round, miterLimit: 0)
        return hitPath?.contains(point) ?? false
    }
    
    func addImagesToNote(images: [CustomImageView]) {
        for image in images {
            insertImage(frame: image.frame, image: image.image!)
        }
    }
}
