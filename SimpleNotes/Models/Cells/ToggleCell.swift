//
//  ToggleCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct ToggleCell: View {
    @State var text: String
    @State var toggleData: Bool
    
    var body: some View {
        Toggle(text, isOn: $toggleData)
    }
}

