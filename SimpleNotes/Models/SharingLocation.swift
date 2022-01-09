//
//  SharingLocation.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit

public enum SharingLocation {
    case messages
    case email
    case otherapps
    
    var viewTitle: String {
        
        switch self {
            case .messages:
                return "Messages"
        case .email:
                return "Email"
        case .otherapps:
                return "Other App"
        }
    }
    
    var buttonMessage: String {
        
        switch self {
            case .messages:
                return "Send via Messages"
        case .email:
                return "Send via Email"
        case .otherapps:
                return "Send to Another app"
        }
    }
}
