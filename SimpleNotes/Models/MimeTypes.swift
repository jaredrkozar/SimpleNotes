//
//  MimeTypes.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/15/22.
//

import UIKit

public enum MimeTypes: CaseIterable {
    case folder
    case pdf
    case document
    case image
    case spreadsheet
    case presentation
    case audiofile
    case other
    
    var icon: String {
        switch self {
            case .folder:
            return "folder"
        case .pdf:
            return "doc.viewfinder"
        case .document:
            return "doc"
        case .spreadsheet:
            return "tablecells"
        case .presentation:
            return "rectangle.grid.2x2"
        case .image:
            return "photo"
        case .audiofile:
            return "mic"
        case .other:
            return "questionmark.circle"
        }
    }
    
    var tintColor: UIColor {
        switch self {
            case .folder:
            return .systemCyan
            case .pdf:
            return .systemOrange
            case .document:
            return .systemBlue
            case .spreadsheet:
            return .systemGreen
            case .presentation:
            return .systemYellow
        case .image:
        return .systemTeal
            case .audiofile:
            return .systemGray
            case .other:
            return .systemPink
        }
    }
    
    var typeURL: String {
        
        switch self {
            case .folder:
                return "folder"
        case .pdf:
                return "pdf"
        case .document:
                return "document"
        case .spreadsheet:
                return "spreadsheet"
        case .presentation:
                return "presentation"
        case .image:
                return "image"
        case .audiofile:
                return "audiofile"
        case .other:
                return "other"
        }
    }
}
