//
//  SettingsData.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

class Storage: ObservableObject {
    @Published var currentText: String = "false"
    @Published var currentBool: Bool = false
    @Published var currentColor: Color = .blue
}

var cloudSection = SettingsSection(headerText: "Cloud", rows: [
    SettingsRow(leftTitle: "Accounts", cellConfig: .icon(icon: Icon(icon: "cloud", iconBGColor: Color.blue, iconTintColor: Color.white), childRows: [accountSection, accountSection, colorSection]))
], footerText: "Change account settings")

var accountSection = SettingsSection(headerText: "", rows: [
    SettingsRow(leftTitle: "Accounts", cellConfig: .text(leftText: "LELELE", currentText: Storage().currentText, placeholderText: "PLACEHOLDER"))
    
    
], footerText: "")

var colorSection = SettingsSection(headerText: "Tint Color", rows: [
    SettingsRow(leftTitle: "Tint COlor", cellConfig: .color)
    
], footerText: "")


