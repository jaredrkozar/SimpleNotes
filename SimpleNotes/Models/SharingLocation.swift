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
        }
    }
}
