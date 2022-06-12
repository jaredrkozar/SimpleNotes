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
    case spreadsheet
    case presentation
    case audiofile
    case other
    
    var icon: UIImage {
        switch self {
            case .folder:
            return (UIImage(systemName: "folder")?.withTintColor(UIColor.systemCyan, renderingMode: .alwaysOriginal))!
        case .pdf:
            return (UIImage(systemName: "doc.viewfinder")?.withTintColor(UIColor.systemRed, renderingMode: .alwaysOriginal))!
        case .document:
            return (UIImage(systemName: "doc")?.withTintColor(UIColor.systemBlue, renderingMode: .alwaysOriginal))!
        case .spreadsheet:
            return (UIImage(systemName: "tablecells")?.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal))!
            
        case .presentation:
            return (UIImage(systemName: "rectangle.grid.2x2")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal))!
        case .audiofile:
            return (UIImage(systemName: "mic")?.withTintColor(UIColor.systemPink, renderingMode: .alwaysOriginal))!
        case .other:
            return (UIImage(systemName: "questionmark.circle")?.withTintColor(UIColor.systemPurple, renderingMode: .alwaysOriginal))!
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
        case .audiofile:
                return "audiofile"
        case .other:
                return "other"
        }
    }
}
