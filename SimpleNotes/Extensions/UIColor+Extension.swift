//
//  UIColor+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import UIKit
import SwiftUI

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

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
            }

            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue:  Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
}
