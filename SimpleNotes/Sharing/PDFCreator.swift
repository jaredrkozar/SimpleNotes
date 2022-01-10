//
//  PDFCreator.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit

class PDFCreator {

    func createPDF(noteTitle: String, noteText: String?, noteDate: String) -> Data {
        let pdfMetaData = [kCGPDFContextTitle: noteTitle]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in

            context.beginPage()

            let titleBottom = addTitle(noteTitle: noteTitle, pageRect: pageRect)
        }
        
        return data
    }
    
    func addTitle(noteTitle: String, pageRect: CGRect) -> CGFloat {

      let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
  
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
 
      let attributedTitle = NSAttributedString(
        string: noteTitle,
        attributes: titleAttributes
      )
        
      let titleStringSize = attributedTitle.size()

      let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: 36,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
        
      attributedTitle.draw(in: titleStringRect)

      return titleStringRect.origin.y + titleStringRect.size.height
    }

}
