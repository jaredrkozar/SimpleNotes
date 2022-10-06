//
//  UIImageView+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import UIKit

extension UIImage {
    func resizeImage(dimension: CGFloat) -> CGRect {
        let maxDimension =  CGFloat(max(self.size.width, self.size.height))
        let scale = dimension / maxDimension
        var rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        rect = rect.applying(transform)
        
        return rect
    }
    
    func converttoString() -> String {
        let data = self.jpegData(compressionQuality: 1)
        return (data?.base64EncodedString(options: .endLineWithLineFeed))!
            
    }
}
