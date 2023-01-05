//
//  ToggleCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct ToggleCell: View {
    @State var text: String
    @Binding var enabled: Bool
    var body: some View {
        Toggle(text, isOn: $enabled)
    }
}

struct ToggleCell_Previews: PreviewProvider {
    @State static var showingAddUser = false
    static var previews: some View {
        ToggleCell(text: "Dark mode", enabled: $showingAddUser)
    }
}
