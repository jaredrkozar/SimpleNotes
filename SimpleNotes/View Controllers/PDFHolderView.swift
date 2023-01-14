//
//  PDFHolderView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/11/22.
//

import UIKit
import PDFKit

class PDFHolderView: UIView, UIScrollViewDelegate, UIDropInteractionDelegate {

    var pdfDocument: PDFDocument?
    
    private var offsets = [Border]()
    
    private var visiblePages = [CustomPDFPage]()
    
    private var pageDisplayType: PageDisplayType?
    
    private var currentPage: Int? = 0
    
    public var drawingView = DrawingView(frame: .zero)
    private let pdfHolderView = UIView(frame: .zero)
    private var baseView = UIView(frame: .zero)
    
    private let scrollView = UIScrollView(frame: .zero)
    private var rect = CGRect()
    
    public var tool: Tools {
        get {
            return drawingView.tool ?? .pen
        }
        set {
            drawingView.currentView?.isNotCurrentView()
            if newValue == .scroll {
                self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
                drawingView.isUserInteractionEnabled = true
            } else {
                self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
            }
            drawingView.tool = newValue
        }
    }
    
    
    init(pdfDocument: PDFDocument?, frame: CGRect, defaultScrollDirection: PageDisplayType, index: Int) {
        self.pdfDocument = pdfDocument
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.addInteraction(UIDropInteraction(delegate: self))
        
        drawingView.addImagesToNote(images: fetchImages(index: index))
        drawingView.insertedImage = { image, frame in
            saveImage(image: image, frame: frame, index: index)
        }
        
        drawingView.deleteImage = { imageindex in
            removeImage(index: imageindex, noteIndex: index)
        }
        
        drawingView.insertedStroke = { stroke in
            print("DLLDLD")
        }
        
       pageDisplayType = defaultScrollDirection
        drawingView.backgroundColor = .clear
        
        baseView.addSubview(pdfHolderView)
        baseView.addSubview(drawingView)
        baseView.backgroundColor = .red
        self.addSubview(scrollView)
        scrollView.addSubview(baseView)
        scrollView.delegate = self
        scrollView.backgroundColor = .purple
        
        offsets.append(contentsOf: getAllPageOffsets(page: (pdfDocument?.page(at: 0))!, numberOfPages: pdfDocument!.pageCount))
   
        var rect = CGRect()
  
        switch pageDisplayType {
                       case .horizontal:
            rect = CGRect(x: 0, y: 0, width: offsets.last!.maxX, height: self.frame.height)
                           break
           case .vertical:
            rect = CGRect(x: 0, y: 0, width: self.frame.width, height: offsets.last!.maxY)
                break
           default:
               return
           }
        
        drawFirstCouplePages(range: (0 ..< min(3, pdfDocument!.pageCount)))
        scrollView.frame = frame
        scrollView.contentSize = rect.size
        drawingView.frame = rect
        pdfHolderView.frame = rect
        baseView.frame = rect
    
        drawingView.contentScaleFactor = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawFirstCouplePages(range: CountableRange<Int>) {
        visiblePages.forEach({$0.removeFromSuperview()})
        visiblePages.removeAll()
        for counter in range
        {
            visiblePages.append(drawPage(num: counter))
        }
    }
    
    func returnRange(currentPageNum: Int) -> CountableRange<Int> {
        if (currentPageNum - 2 < 0){
            return 0 ..< min(pdfDocument!.pageCount, 3)
          }
        else if (currentPageNum != pdfDocument?.pageCount){
              return currentPageNum - 2 ..< currentPageNum + 1
          }
          else{
              return currentPageNum - 3 ..< currentPageNum
          }
    }
    
    func goToPage(pageNum: Int) {
        currentPage = min(pdfDocument!.pageCount, max(pageNum, 1))
        drawFirstCouplePages(range: returnRange(currentPageNum: currentPage!))
        scrollView.setContentOffset(CGPoint(x: self.offsets[pageNum - 1].minX, y: self.offsets[pageNum - 1].minY), animated: true)
    }
    
    func getAllPageOffsets(page: PDFPage, numberOfPages: Int) -> [Border] {
        let pageSize = CGSize(width: (page.bounds(for: .mediaBox).width), height: (page.bounds(for: .artBox).height))
        var offsets = [Border]()
               
        if (pageDisplayType == .vertical){
            offsets.append(Border(minX: 0, minY: 0, maxX: self.frame.width, maxY: pageSize.height))
       } else {
           offsets.append(Border(minX: 0, minY: 0, maxX: pageSize.width, maxY: self.frame.height))
       }
        
       for counter in  1 ..< numberOfPages{
           let upPage = pdfDocument!.page(at: counter)
           var lastPage = offsets.last
    
           let border: Border
           switch pageDisplayType {
           case .horizontal:
               border = Border(minX: lastPage!.maxX, minY: lastPage!.minY, maxX: lastPage!.maxX + (upPage!.bounds(for: .artBox).width), maxY: lastPage!.maxY)
                           break
                       case .vertical:
               border = Border(minX: lastPage!.minX, minY:offsets[counter - 1].maxY, maxX: lastPage!.maxX, maxY: lastPage!.maxY + (upPage!.bounds(for: .artBox).height))
                           break
           default:
               border = Border(minX: pdfHolderView.bounds.minX, minY: pdfHolderView.bounds.minY, maxX: pdfHolderView.bounds.maxX, maxY: pdfHolderView.bounds.maxY)
           }
           
           offsets.append(border)
       }
       return offsets
    }

    func drawPage(num: Int) -> CustomPDFPage {
        let page = pdfDocument?.page(at: num)
        
        let pdfpage = CustomPDFPage(frame: CGRect(x: offsets[num].minX, y: offsets[num].minY, width: offsets[num].maxX - offsets[num].minX, height: offsets[num].maxY - offsets[num].minY), page: page, pageNumber: num)
        
        pdfHolderView.addSubview(pdfpage)
        return pdfpage
    }
    
    func returnExport(exportType: SharingType) -> [Data] {
        var returnData: [Data]?
        switch exportType {
            case .image:
              returnData = exportAsImage()
            case .pdf:
            returnData = [exportAsPDF()]
        }
        return returnData!
    }
    
    private func exportAsImage() -> [Data] {
        var newImage = [Data]()
        let dpi: CGFloat = 300.0 / 72.0
        let pageRect = pdfDocument?.page(at: 1)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: (pageRect?.bounds(for: .artBox).width)!, height: (pageRect?.bounds(for: .artBox).height)!))
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        for counter in 0..<pdfDocument!.pageCount {
            let image = renderer.image { (context) in
                UIColor.white.setFill()
                context.fill(pageRect?.bounds(for: .artBox) ?? CGRect(x: 0, y: 0, width: 100, height: 100))
                context.cgContext.translateBy(x: 0.0, y: (pageRect?.bounds(for: .artBox).height) ?? 0)
                context.cgContext.scaleBy(x: 1.0, y: -1.0)
                scrollView.layer.render(in: context.cgContext)
            }
            newImage.append(image.pngData()!)
        }
        return newImage
    }
    
    private func exportAsPDF() -> Data {
        let newPDF = NSMutableData()
        UIGraphicsBeginPDFContextToData(newPDF, CGRect(x: 0,y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height), nil)
        let context = UIGraphicsGetCurrentContext()
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        for counter in 0 ..< pdfDocument!.pageCount {
          
            scrollView.setContentOffset(CGPoint(x: offsets[counter].minX, y: offsets[counter].minY), animated: false)
                        switch self.pageDisplayType {
                        case .horizontal:
                            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY, width: (offsets[counter].maxX - offsets[counter].minX), height: scrollView.frame.height)
                        case .vertical:
                            scrollView.frame = CGRect(x: scrollView.frame.minX, y: scrollView.frame.minY, width: scrollView.frame.width, height: (offsets[counter].maxY - offsets[counter].minY))
                        case .none:
                            scrollView.frame = .zero
                        }
                        
                        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), nil)
            
                        context!.translateBy(x: -offsets[counter].minX, y: -offsets[counter].minY)
            
            scrollView.layer.render(in: context!)
        }
        
        UIGraphicsEndPDFContext()
        return newPDF as Data
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return baseView
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch self.pageDisplayType {
        case .horizontal:
            self.updateHorizontal(scrollView)
            break
        case .vertical:
            self.updateVertical(scrollView)
            break
        case .none:
            print("DK")
        }
    }
    
    private func checkBelow(offset: CGFloat, test: CGFloat) -> Bool{
        return test - offset < self.frame.height && test >= offset
    }
    
    private func checkAbove(offset: CGFloat, test: CGFloat) -> Bool{
        return offset - test < self.frame.height && offset >= test
    }
    
    private func updateHorizontal(_ scrollView: UIScrollView) {
        if (visiblePages[0].pageNumber! > 0){
            if (checkAbove(offset: scrollView.contentOffset.x, test: offsets[visiblePages[0].pageNumber!].minX)){
                self.visiblePages.last?.removeFromSuperview()
                self.visiblePages.removeLast()
                self.visiblePages.insert(self.drawPage(num: visiblePages[0].pageNumber! - 1), at: 0)
            }
        }
        if let last = visiblePages.last, (last.pageNumber! < pdfDocument!.pageCount - 1){
            if (checkBelow(offset: scrollView.contentOffset.x / scrollView.zoomScale, test: offsets[last.pageNumber!].maxX)){
                self.visiblePages[0].removeFromSuperview()
                self.visiblePages.removeFirst()
                self.visiblePages.append(self.drawPage(num: last.pageNumber! + 1))
            }
        }
    }
    
    private func updateVertical(_ scrollView: UIScrollView)  {
        if (visiblePages[0].pageNumber! > 0){
            if (checkAbove(offset: scrollView.contentOffset.y / scrollView.zoomScale, test: offsets[visiblePages[0].pageNumber!].minY)){
                self.visiblePages.last?.removeFromSuperview()
                self.visiblePages.removeLast()
                self.visiblePages.insert(self.drawPage(num: visiblePages[0].pageNumber! - 1), at: 0)
            }
        }
        
        if let last = visiblePages.last, (last.pageNumber! < pdfDocument!.pageCount - 1){
            
            if (checkBelow(offset: scrollView.contentOffset.y / scrollView.zoomScale, test: offsets[last.pageNumber!].maxY)){
                self.visiblePages[0].removeFromSuperview()
                self.visiblePages.removeFirst()
                self.visiblePages.append(self.drawPage(num: last.pageNumber! + 1))
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Ensure the drop session has an object of the appropriate type
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
            // Propose to the system to copy the item from the source app
            return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                
                if let err = err {
                    print("Failed to load our dragged item:", err)
                    return
                }
                
                guard let draggedImage = obj as? UIImage else { return }
                
                DispatchQueue.main.async {
                    
                    var imageFrame = draggedImage.returnFrame(location: session.location(in: interaction.view!))
                    
                    if imageFrame.maxX > self.bounds.width {
                        imageFrame.origin.x = self.frame.width - imageFrame.width
                    }
                    
                    if imageFrame.minX < 0 {
                        imageFrame.origin.x = 0
                    }
                    
                    if imageFrame.maxY > self.bounds.height {
                        imageFrame.origin.y = self.frame.height - imageFrame.height
                    }
                    
                    if imageFrame.minY < 0 {
                        imageFrame.origin.y = 0
                    }
                    
                    self.drawingView.insertImage(frame: imageFrame, image: draggedImage)
                }
                
            })
        }
    }
}
