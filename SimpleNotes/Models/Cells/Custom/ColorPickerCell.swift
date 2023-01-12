//
//  ColorPickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct ColorPickerCell: View {
    @Binding var currentValue: Int
    @State var tappedAction: ((Int) -> Void)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Array(ThemeColors.allCases.enumerated()), id: \.element) { index, color in
                    ColorCell(color: color.tintColor, text: color.themeName, index: index, currentValue: $currentValue, tappedAction: tappedAction)
                }
            }
        }
        .frame(height: 150)
    }
}

private struct ColorCell: View {
    @State var color: Color
    @State var text: String
    @State var index: Int
    @Binding var currentValue: Int
    @State var tappedAction: ((Int) -> Void)
    
    var body: some View {
        Button(action: {
            currentValue = index
            tappedAction(currentValue)
        }) {
            ZStack {
                VStack {
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                    
                    Text(text)
                        .frame(width: 80, height: 60)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .contentShape(Rectangle())
        }
        
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color, lineWidth:  index == currentValue ? 4.0 : 0.0)
        )
        .buttonStyle(BaseButtonStyle())
        
        .padding(10)
        
    }
}

