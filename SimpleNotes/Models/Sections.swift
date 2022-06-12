//
//  Sections.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/2/22.
//

import UIKit

struct Sections {
    let title: String?
    var settings: [SettingsOptions]
}

struct SettingsOptions {
    let title: String
    var option: String
    let icon: UIImage?
    let iconBGColor: UIColor?
    let detailViewType: DetailViewType?
    let handler: (() -> Void)?
}

enum DetailViewType: Equatable {
    
    case color(color: UIView)
    case text(string: String)
    case control(controls: [UIControl])
}
