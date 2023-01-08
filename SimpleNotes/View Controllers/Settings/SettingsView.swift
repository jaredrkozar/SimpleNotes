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
    
    var defaultSettings = [IconCell(iconName: Icon(icon: "doc", iconBGColor: Color.red, iconTintColor: Color.white), title: "Note", view: AnyView(DefaultNoteSettings())),
        
        IconCell(iconName: Icon(icon: "doc", iconBGColor: Color.red, iconTintColor: Color.white), title: "Note", view: nil)]

    var body: some View {
        NavigationSplitView {
            List(defaultSettings, selection: $selection) { cell in
            NavigationLink(value: cell) {
              cell
            }
          }
          .navigationTitle("World")
            
        } detail: {
            if let country = selection {
                if country.view != nil {
                    
                    AnyView(country.view)
                }
            
          } else {
            Text("Select a country")
          }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
