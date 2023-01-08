//
//  ToggleCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct ToggleCell: View, SettingsCell {
    @State var text: String
    @Binding var toggleData: Bool
    @Binding var tintColor: Int
    
    var body: some View {
        Toggle(text, isOn: $toggleData)
            .tint(ThemeColors(rawValue: tintColor)?.tintColor)
    }
}

