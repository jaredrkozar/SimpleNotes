//
//  PDFPage.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 9/22/22.
//

import UIKit
import PDFKit

class CustomPDFPage: UIView {

    public var page: PDFPage?
    public var pageNumber: Int?
    
    init(frame: CGRect, page: PDFPage?, pageNumber: Int?)
    {
        super.init(frame: frame)
        self.frame = frame
        self.page = page
        self.pageNumber = pageNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        UIColor.white.setFill()
        context.fill(rect)
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1, y: -1)
        page?.draw(with: .artBox, to: context)

        let path = UIBezierPath()
        path.lineWidth = 3.0
               path.move(to: CGPoint(x: 0,y: self.bounds.minY))
               path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
               path.move(to: CGPoint(x: 0, y: 0))
               path.addLine(to: CGPoint(x: 0, y: self.bounds.maxY))
               path.move(to: CGPoint(x: self.bounds.maxX, y: 0))
               path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
               path.move(to: CGPoint(x: 0, y: 0))
               path.addLine(to: CGPoint(x: self.bounds.maxX, y: 0))
               UIColor.lightGray.setStroke()
               path.stroke()
    }
}
