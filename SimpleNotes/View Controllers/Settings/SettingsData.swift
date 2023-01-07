//
//  SettingsData.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct DefaultNoteSettings: View {
    @AppStorage("defaultNoteTitle") var defaultNoteTitle: String = "Anonymous"
    
    var body: some View {
        List {
            Section(header: Text("Defaults")) {
                TextCell(currentText: $defaultNoteTitle, placeholder: "Note Title", leftText: "Default Note Title")
            }
        }
    }
}
