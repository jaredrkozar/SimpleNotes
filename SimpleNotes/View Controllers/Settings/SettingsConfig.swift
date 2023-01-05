//
//  SettingsConfig.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import Foundation
import SwiftUI

struct SettingsSection: Identifiable {
    let id = UUID()
    var headerText: String
    var rows = [SettingsRow]()
    var footerText: String
}

struct SettingsRow: Identifiable {
    let id = UUID()
    //the text on the left side of the cell
    var leftTitle: String
    
    var cellConfig: CellType
    
    enum CellType {
        case toggle(
            bindingVariable: Binding<Bool>
        )
        case popup(
            popupView: (() -> Void)?
        )
        case stepper(
            stepperMinValue: Int,
            stepperMaxValue: Int,
            bindingVariable: Int
        )
        case icon(
            icon: Icon,
            childRows: [SettingsSection]?
        )
        case text(
            leftText: String,
            currentText: String,
            placeholderText: String
        )
        case color
    }
}
