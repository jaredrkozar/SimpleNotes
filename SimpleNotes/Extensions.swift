//
//  Extensions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/18/21.
//

import UIKit

var notes: [Note] = []
var tags: [AllTags] = []
var currentNote: Note?

public var currentDevice: Device?

public enum StrokeTypes {
    case normal
    case dotted
    case dashed
}

public enum Tools {
    case pen
    case highlighter
    case eraser
    case lasso
    case text
    case hand
}

public enum Device {
    case iphone
    case ipad
    case mac
}

public enum SharingType {
    case pdf
    case plainText
}

func sendBackSymbol(imageName: String, color: UIColor) -> UIImage {
    return UIImage(systemName: imageName)!.withTintColor(color, renderingMode: .alwaysOriginal)
}


extension UIView {

    func moveBy(x: CGFloat, y: CGFloat)
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x + x, y: self.frame.origin.y + y)
    }

    
    func createPDF() -> NSMutableData
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil)
        UIGraphicsBeginPDFPage()

        let pdfContext = UIGraphicsGetCurrentContext()!

        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        return pdfData
    }
    
    func createImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIColor {

    // MARK: - Initialization

    // MARK: - Convenience Methods
    convenience init?(hex: String) {
         var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
         hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")

         // Helpers
         var rgb: UInt32 = 0
         var r: CGFloat = 0.0
         var g: CGFloat = 0.0
         var b: CGFloat = 0.0
         var a: CGFloat = 1.0
         let length = hexNormalized.count

         // Create Scanner
         Scanner(string: hexNormalized).scanHexInt32(&rgb)

         if length == 6 {
             r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
             g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
             b = CGFloat(rgb & 0x0000FF) / 255.0

         } else if length == 8 {
             r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
             g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
             b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
             a = CGFloat(rgb & 0x000000FF) / 255.0

         } else {
             return nil
         }

         self.init(red: r, green: g, blue: b, alpha: a)
     }
    
    var toHex: String? {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        // Helpers
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        // Create Hex String
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))

        return hex
    }
    
}
