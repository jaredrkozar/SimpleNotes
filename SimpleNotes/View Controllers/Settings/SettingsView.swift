//
//  SettingsView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct SettingsView: View {
    @State var rows: [SettingsSection] = {
        [
            cloudSection
        ]
    }()
    @State var title: String = "Settings"
    
    var body: some View {
        List {
        ForEach(rows) { section in
                Section(header: Text(section.headerText), footer: Text(section.footerText)) {
                    ForEach(section.rows) { settingsCell in
                        switch settingsCell.cellConfig {
                        case .icon(icon: let cellIcoj, childRows: let childrenRows):
                            NavigationLink( destination:
                                            SettingsView(rows: childrenRows!, title: settingsCell.leftTitle)
                            ) {
                                IconCell(iconName: Icon(icon: cellIcoj.icon, iconBGColor: cellIcoj.iconBGColor, iconTintColor: cellIcoj.iconTintColor), title: settingsCell.leftTitle, arrowAccessory: true)
                            }
                        case .toggle(bindingVariable: let variable):
                            ToggleCell(text: settingsCell.leftTitle, enabled: variable)
                        case .popup(popupView: let popupView):
                            Text("LLDLDL")
                        case .stepper(stepperMinValue: let stepperMinValue, stepperMaxValue: let stepperMaxValue, bindingVariable: let bindingVariable):
                            Text("LLDLDL")
                        case .text(leftText: let leftText, currentText: let currentText, placeholderText: let placeholderText):
                            TextCell(currentText: currentText, placeholder: placeholderText, leftText: leftText)
                        case .color:
                            ColorPickerCell()
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle(title)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
