//
//  String+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import Foundation
import UIKit

extension String {
    
    func widthOfString() -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        return self.size(withAttributes: fontAttributes)
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
