//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import SwiftUI

struct NewTagViewController: View {
    @State var name: String = ""
    
    @State var icon: String?
    
    @State var color: Int = 0
    
    @State private var showingIconSheet = false
    
    var body: some View {
        SectionView(settings: [
            SettingsGroup(header: "Name", settings: [
                AnyView(TextCell(currentText: $name, placeholder: "Enter tag name", leftText: "Tag name"))
            ], footer: "Type the name of the tag."),
            
            SettingsGroup(header: "Icon", settings: [
                AnyView(TextCell(currentText: $name, placeholder: "Enter tag name", leftText: "Tag name"))
            ], footer: "Select the icon for this tag."),
            SettingsGroup(header: "Color", settings: [
                AnyView(ColorPickerCell(currentValue: $color) {index in
                    print(index)
                })
            ], footer: "Select the tint color for the icon.")
        ])
    }
}
