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
    
    init(frame: CGRect, page: PDFPage?)
    {
        super.init(frame: frame)
        self.frame = frame
        self.page = page
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        page?.draw(with: .artBox, to: context)
        UIColor.white.setFill()
        let rect = UIBezierPath()
        rect.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        rect.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        rect.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        rect.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        UIColor.lightGray.setStroke()
        rect.stroke()
    }
}
