//
//  SharingLocation.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit

public enum SharingLocation: CaseIterable {
    case messages
    case email
    case otherapps
    case googledrive
    case dropbox
    case scanDocument
    case files
    case print
    
    var icon: UIImage {
        switch self {
            case .messages:
            return UIImage(systemName: "message")!
        case .email:
            return UIImage(systemName: "envelope")!
        case .otherapps:
            return UIImage(systemName: "square.and.arrow.up")!
        case .googledrive:
            return UIImage(named: "GoogleDrive")!
        case .dropbox:
            return UIImage(named: "Dropbox")!
        case .scanDocument:
            return UIImage(systemName: "doc.viewfinder")!
        case .files:
            return UIImage(systemName: "folder")!
        case .print:
            return UIImage(systemName: "printer")!
        }
    }
    
    var viewTitle: String {
        
        switch self {
            case .messages:
                return "Messages"
        case .email:
                return "Email"
        case .otherapps:
                return "Other App"
        case .googledrive:
                return "Google Drive"
        case .dropbox:
                return "Dropbox"
        case .scanDocument:
                return "Scan Document"
        case .files:
                return "Files"
        case .print:
            return "Print Note"
        }
    }
    
    var buttonMessage: String {
        
        switch self {
            case .messages:
                return "Send via Messages"
        case .email:
                return "Send via Email"
        case .otherapps:
                return "Send to Another App"
        case .googledrive:
                return "Upload to Google Drive"
        case .dropbox:
                return "Upload to Dropbox"
        case .scanDocument:
                return ""
        case .files:
                return "Send to Files"
        case .print:
                return "Print Note"
        }
    }
    
    var canImport: Bool {
        
        switch self {
        case .scanDocument, .dropbox, .files, .googledrive:
            return true
        default:
            return false
        }
    }
    
    var canExport: Bool {
        
        switch self {
        case .messages, .files, .googledrive, .dropbox, .email, .otherapps, .print:
                return true
        case .scanDocument:
            return false
        }
    }
}

extension SharingLocation {
    var currentLocation: APIInteractor {
        if self == .googledrive {
            return GoogleInteractor()
        } else {
            return DropboxInteractor()
        }
    }
}
