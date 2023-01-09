//
//  Extensions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/18/21.
//

import UIKit
import PDFKit
import SwiftUI

var notes: [Note] = []
var tags: [Tags] = []

var currentNote: Note?

public var currentDevice: Device?

protocol DateHandler {
    func dateHandler() -> Date
}

protocol TagHandler {
    func tagHandler() -> String
}

protocol ModalHandler {
    func modalDismissed()
}

enum CloudType {
    case upload
    case download
}

enum PageDisplayType: String {
    case vertical = "Vertical"
    case horizontal = "Horixontal"
}

public enum StrokeTypes: Int {
    case normal
    case dotted
    case dashed
}

public enum sortOptions: CaseIterable {
    case titleAscending
    case titleDescending
    case dateAscending
    case dateDescending
    
    var title: String {
        switch self {
        case .dateAscending:
            return "Date (Ascending)"
        case .dateDescending:
            return "Date (Descending)"
        case .titleAscending:
            return "Title (Ascending)"
        case .titleDescending:
            return "Title (Descending)"
        
        }
    }
    
    var sortType: String {
        switch self {
        case .titleAscending, .titleDescending:
            return "title"
        case .dateAscending, .dateDescending:
            return "date"
        }
    }
    var ascending: Bool {
        switch self {
        case .dateAscending, .titleAscending:
            return true
        case .dateDescending, .titleDescending:
            return false
        }
    }
}

public enum viewOptions: CaseIterable {
    case grid
    case list
    
    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .list:
            return "List"
        
        }
    }
    
    var icon: String {
        switch self {
        case .grid:
            return "square.grid.2x2"
        case .list:
            return "list.bullet"
        }
    }
}

public enum Tools: Int, CaseIterable {
    case pen
    case highlighter
    case eraser
    case lasso
    case text
    case scroll
    
    
    var name: String {
        switch self {
        case .pen:
            return "Pen"
        case .highlighter:
            return "Highlighter"
        case .eraser:
            return "Eraser"
        case .lasso:
            return "Lasso"
        case .text:
            return "Text"
        case .scroll:
            return "Scroll"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .text:
            return UIImage(systemName: "character.textbox")!
        case .scroll:
            return UIImage(systemName: "hand.point.up.left")!
        case .eraser:
            return UIImage(systemName: "pin")!
        case .pen:
            return UIImage(systemName: "rectangle.on.rectangle")!
        case .highlighter:
            return UIImage(systemName: "rectangle.on.rectangle.circle.fill")!
        case .lasso:
            return UIImage(systemName: "lasso")!
        }
   
    }
    
    var optionsView: UIViewController? {
        switch self {
        case .pen:
            return ToolOptionsViewController()
        case .highlighter:
            return ToolOptionsViewController()
        case .eraser:
            return nil
        case .lasso:
            return nil
        case .scroll:
            return nil
        case .text:
            return nil
        }
    }
}

public enum Device {
    case iphone
    case ipad
    case mac
}

public enum SharingType {
    case pdf
    case image
    
    var googleDriveFileType: String {
        switch self {
            case .pdf:
            return "application/pdf"
            case .image:
            return "application/zip"
        }
    }
    
    var dropboxFileType: String {
        switch self {
            case .pdf:
            return "pdf"
            case .image:
            return "png"
        }
    }
}

struct Sections {
    let title: String?
    var settings: [SettingsOptions]
}

struct SettingsOptions {
    let title: String
    var option: String?
    let rowIcon: Icon?
    let control: DetailViewType?
    let handler: (() -> Void)?
}

struct Icon {
    let icon: String?
    let iconBGColor: Color!
    let iconTintColor: Color!
}

enum DetailViewType: Equatable {
    
    case color(color: UIView)
    case text(string: String)
    case control(controls: [UIControl], width: Double)
}

func sendBackSymbol(imageName: String, color: UIColor) -> UIImage {
    return UIImage(systemName: imageName)!.withTintColor(color, renderingMode: .alwaysOriginal)
}

func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
        return false
    }
}

extension PDFPage {
    func createThumbnail() -> Data {
        let newThumbanil = self.thumbnail(of: CGSize(width: 1150, height: 150), for: .artBox)
        return newThumbanil.jpegData(compressionQuality: 0.6)!
    }
}

extension UIImage {
    func returnFrame(location: CGPoint?) -> CGRect {
        let newRect = self.resizeImage(dimension: 400)
        
        return CGRect(x: ((location?.x ?? newRect.width) + (-1 * CGFloat(newRect.width) / 2)), y: ((location?.y ?? newRect.height) + (-1 * CGFloat(newRect.height) / 2)), width: newRect.width, height: newRect.height)
    }
}

enum ThemeColors: Int, CaseIterable, Identifiable {
    var id: Self { self }
    
    case red
    case orange
    case yellow
    case green
    case lightBlue
    case darkBlue
    
    var tintColor: Color {
        switch self {
            case .red:
                return Color.red
            case .orange:
                return Color.orange
            case .yellow:
                return Color.yellow
            case .green:
                return Color.green
            case .lightBlue:
                return Color.cyan
            case .darkBlue:
                return Color.blue
        }
    }
    
    var themeName: String {
        switch self {
            case .red:
                return "Fiery Red"
            case .orange:
                return "Atomic Orange"
            case .yellow:
                return "Mango Yellow"
            case .green:
                return "Grassy Green"
            case .lightBlue:
                return "Pastel Blue"
            case .darkBlue:
                return "Ocean Blue"
        }
    }
    
    var returnUIColor: UIColor {
        switch self {
            case .red:
                return UIColor.systemRed
            case .orange:
                return UIColor.systemOrange
            case .yellow:
                return UIColor.systemYellow
            case .green:
                return UIColor.systemGreen
            case .lightBlue:
                return UIColor.systemCyan
            case .darkBlue:
                return UIColor.systemBlue
        }
    }
}
