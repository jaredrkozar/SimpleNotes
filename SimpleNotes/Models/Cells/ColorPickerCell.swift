//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct ColorPickerCell: View {
    
    var body: some View {
        HStack {
            ForEach(ThemeColors.allCases) { color in
                ColorCell(color: color)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .padding(Constants.rowHorizontalInsets)
        .padding(Constants.rowVerticalInsetsFromText)
    }
}

private struct ColorCell: View {
    @State var color: ThemeColors

    var body: some View {
        Button(action: {
            UserDefaults.standard.set(color.tintColor.toHex(), forKey: "defaultTintColor")
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
        .frame(width: 100, height: 110, alignment: .center)
        .background(Color.green)
        .cornerRadius(15)
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorPickerCell_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerCell()
    }
}
