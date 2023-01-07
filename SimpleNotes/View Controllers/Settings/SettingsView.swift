//
//  SettingsView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct SettingsView: View {

    @State var title: String = "Settings"
    
    var body: some View {
        List {
            IconCell(iconName: Icon(icon: "doc", iconBGColor: Color.red, iconTintColor: Color.white), title: "Note", view: AnyView(DefaultNoteSettings()))
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
