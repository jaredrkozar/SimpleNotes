//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct ColorPickerCell: View {
    @Binding var currentTintColor: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<ThemeColors.allCases.count) { color in
                    ColorCell(colorID: color, currentValue: $currentTintColor)
                }
            }
        }
        .frame(height: 150)
    }
}

private struct ColorCell: View {
    @State var colorID: Int
    @Binding var currentValue: Int
    
    var body: some View {
        let currentColor = ThemeColors(rawValue: colorID)
        Button(action: {
            UserDefaults.standard.set(colorID, forKey: "defaultTintColor")
            currentValue = colorID
            NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        }) {
            ZStack {
                VStack {
                    Circle()
                        .fill(currentColor!.tintColor)
                        .frame(width: 30, height: 30)
                    
                    Text(currentColor!.themeName)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 100, alignment: .center)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .quaternarySystemFill))
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(15)
    
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(currentColor!.tintColor, lineWidth: currentColor?.tintColor.toHex() == ThemeColors(rawValue: currentValue)?.tintColor.toHex() ? 4.0 : 0.0)
        )
        .padding(10)
        
    }
}

