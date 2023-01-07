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
    
    var body: some View {
        Toggle(text, isOn: $toggleData)
    }
}

