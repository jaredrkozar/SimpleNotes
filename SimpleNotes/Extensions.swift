//
//  Extensions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/18/21.
//

import UIKit

var notes: [Note] = []
var tags: [AllTags] = []
var currentTag: String?

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

extension String {
    func sendBackSymbol(color: String) -> UIImage {
        print(self)
        return UIImage(systemName: self)!.withTintColor(UIColor(named: color)!, renderingMode: .alwaysOriginal)
    }
}
