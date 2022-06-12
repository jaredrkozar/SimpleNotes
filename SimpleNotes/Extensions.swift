//
//  Extensions.swift
//  SimpleNotes
//f
//  Created by JaredKozar on 12/18/21.
//

import UIKit

var notes: [Note] = []
var tags: [AllTags] = []

var currentNote: Note?

public var currentDevice: Device?

protocol ModalHandler {
    func modalDismissed()
}

public enum StrokeTypes: Int {
    case normal
    case dotted
    case dashed
}

public enum sortOptions: CaseIterable {
    case titleAscending
    case titleDescending
    case dateAscending
    case dateDescending
    
    var title: String {
        switch self {
        case .dateAscending:
            return "Date (Ascending)"
        case .dateDescending:
            return "Date (Descending)"
        case .titleAscending:
            return "Title (Ascending)"
        case .titleDescending:
            return "Title (Descending)"
        
        }
    }
    
    var sortType: String {
        switch self {
        case .titleAscending, .titleDescending:
            return "title"
        case .dateAscending, .dateDescending:
            return "date"
        }
    }
    var ascending: Bool {
        switch self {
        case .dateAscending, .titleAscending:
            return true
        case .dateDescending, .titleDescending:
            return false
        }
    }
}

public enum viewOptions: CaseIterable {
    case grid
    case list
    
    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .list:
            return "List"
        
        }
    }
    
    var icon: String {
        switch self {
        case .grid:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        }
    }
}

public enum Tools: CaseIterable {
    case pen
    case highlighter
    case eraser
    case lasso
    case text
    case shape
    case hand
    
    var name: String {
        switch self {
        case .pen:
            return "Pen"
        case .highlighter:
            return "Highlighter"
        case .eraser:
            return "Eraser"
        case .lasso:
            return "Lasso"
        case .text:
            return "Text"
        case .shape:
            return "Shape"
        case .hand:
            return "Hand"
        }
    }
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

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
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
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
         return self.adjust(by: -1 * abs(percentage) )
     }

     func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
         var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
         if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
             return UIColor(red: min(red + percentage/100, 1.0),
                            green: min(green + percentage/100, 1.0),
                            blue: min(blue + percentage/100, 1.0),
                            alpha: alpha)
         } else {
             return nil
         }
     }
 }

