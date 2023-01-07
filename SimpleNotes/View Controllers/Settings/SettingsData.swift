//
//  SettingsData.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

protocol SettingsCell {}

struct SettingsGroup: Identifiable {
    let id = UUID()
    var header: String
    var settings: [AnyView]
    var footer: String
}

struct DefaultNoteSettings: View {
    @AppStorage("defaultNoteTitle") var defaultNoteTitle: String = "Anonymous"
    @AppStorage("defaultOnOff") var defaultOnOff: Bool = false
    @AppStorage("storeStepperValue") var stepperValue: Int = 4
    @AppStorage("tintColor") var defaulttintColor: String = Color.green.toHex()!
    
    var body: some View {
        SectionView(settings: [
            SettingsGroup(header: "Hello", settings: [
                AnyView(ToggleCell(text: "On.off", toggleData: $defaultOnOff, tintColor: $defaulttintColor)),
                AnyView(TextCell(currentText: $defaultNoteTitle, placeholder: "NOte", leftText: "LeftText")),
                AnyView(ColorPickerCell(currentTintColor: $defaulttintColor)),
                AnyView(StepperCell(minValue: 1, maxValue: 10, text: "Stepper", currentValue: $stepperValue))
            ], footer: "Goodbye"),
            
            SettingsGroup(header: "Hello", settings: [
                AnyView(ToggleCell(text: "On.off", toggleData: $defaultOnOff, tintColor: $defaulttintColor))
            ], footer: "Goodbye")
        ])
    }
}

struct SectionView: View {
    @State var settings = [SettingsGroup]()

    var body: some View {
        List {
            ForEach(settings) { settinggroup in
                Section(header: Text(settinggroup.header), footer: Text(settinggroup.footer)) {
                
                    ForEach(settinggroup.settings.indices) { i in
                        SettingRowView {
                            settinggroup.settings[i]
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}


struct SettingRowView<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
    }
}
