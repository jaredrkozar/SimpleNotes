//
//  PDFCreator.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit

class PDFCreator {

    var headerFont: Int?
    var bodyFont: Int?
    
    
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

            addTitle(noteTitle: noteTitle, pageRect: pageRect)
            
            addDate(noteDate: noteDate, pageRect: pageRect)
            
            addText(noteText: noteText!, pageRect: pageRect)
        }
        
        return data
    }
    
    func addTitle(noteTitle: String, pageRect: CGRect) -> CGFloat {

      let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
  
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
 
      let attributedTitle = NSAttributedString(
        string: noteTitle,
        attributes: titleAttributes
      )
        
      let titleStringSize = attributedTitle.size()

      let titleStringRect = CGRect(
        x: 30,
        y: 35,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
        
      attributedTitle.draw(in: titleStringRect)

      return titleStringRect.origin.y + titleStringRect.size.height
    }

    func addDate(noteDate: String, pageRect: CGRect) -> CGFloat {

      let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
  
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
 
      let attributedTitle = NSAttributedString(
        string: noteDate,
        attributes: titleAttributes
      )
        
      let titleStringSize = attributedTitle.size()

      let titleStringRect = CGRect(
        x: pageRect.width - 300,
        y: 35,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
        
      attributedTitle.draw(in: titleStringRect)

      return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addText(noteText: String, pageRect: CGRect) -> CGFloat {

        let textFont = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        // 1
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byCharWrapping
     
        
        // 2
        let textAttributes = [
          NSAttributedString.Key.paragraphStyle: paragraphStyle,
          NSAttributedString.Key.font: textFont
          
        ]
        let attributedText = NSAttributedString(
          string: noteText,
          attributes: textAttributes
        )
        
        let titleStringSize = attributedText.size()
        // 3
        let textRect = CGRect(
          x: 30,
          y: 100,
          width: pageRect.width - 50,
          height: pageRect.height - 50
        )
        attributedText.draw(in: textRect)
        
        return textRect.origin.y + textRect.size.height
    }
    
}
