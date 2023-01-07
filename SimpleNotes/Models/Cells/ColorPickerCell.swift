//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct ColorPickerCell: View {
    @Binding var currentTintColor: String
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(ThemeColors.allCases) { color in
                    ColorCell(color: color, currentValue: $currentTintColor)
                }
            }
        }
        .frame(height: 150)
    }
}

private struct ColorCell: View {
    @State var color: ThemeColors
    @Binding var currentValue: String
    
    var body: some View {
        Button(action: {
            UserDefaults.standard.set(color.tintColor.toHex(), forKey: "defaultTintColor")
            currentValue = color.tintColor.toHex()!
            NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        }) {
            ZStack {
                VStack {
                    Circle()
                        .fill(color.tintColor)
                        .frame(width: 30, height: 30)
                    
                    Text(color.themeName)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 100, alignment: .center)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .quaternarySystemFill))
        .cornerRadius(15)
        .buttonStyle(PlainButtonStyle())
    }
}
