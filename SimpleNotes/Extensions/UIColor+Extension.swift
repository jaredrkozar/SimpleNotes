//
//  UIColor+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import UIKit

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
