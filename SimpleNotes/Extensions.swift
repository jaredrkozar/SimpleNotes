//
//  Extensions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/18/21.
//

import UIKit

var notes: [Note] = []
var tags: [AllTags] = []
public var currentDevice: Device?

public enum Device {
    case iphone
    case ipad
    case mac
}

public enum SharingType {
    case pdf
    case plainText
}

extension UIImage {
    func convertToData() -> String {
        let imageData = self.pngData()
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        return imageStr
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
