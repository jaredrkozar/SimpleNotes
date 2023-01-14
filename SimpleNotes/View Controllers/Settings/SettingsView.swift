//
//  SettingsView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selection: IconCell?
    
    @State var title: String = "Settings"
    
    var defaultSettings = [IconCell(icon: RoundedIcon(icon: .systemImage(iconName: "cloud", backgroundColor: .blue, tintColor: .white)), title: "Accounts", view: AnyView(AccountsSettings())),
                           
       IconCell(icon: RoundedIcon(icon: .systemImage(iconName: "doc", backgroundColor: .red, tintColor: .white)), title: "Note", view: AnyView(DefaultNoteSettings()))]

    var body: some View {
        NavigationSplitView {
            List(defaultSettings, selection: $selection) { cell in
            NavigationLink(value: cell) {
              cell
            }
          }
            
          .navigationTitle("World")
          
        } detail: {
            if let setting = selection {
                AnyView(setting.view)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
