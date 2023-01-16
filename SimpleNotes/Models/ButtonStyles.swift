//
//  HoldingClass.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/24/22.
//

import SwiftUI

struct BaseButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 100, alignment: .center)
            .frame(maxHeight: .infinity)
            .background(Color(uiColor: .quaternarySystemFill))
            .buttonStyle(PlainButtonStyle())
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

enum IconTypes {
    case systemImage(iconName: String, backgroundColor: Color, tintColor: Color)
    case customImage(iconName: String, backgroundColor: Color, paddingInset: Int)
}

struct RoundedIcon: View {
    var icon: IconTypes
    
    var body: some View {
        ZStack {
            
            switch icon {
            case .systemImage(iconName: let name, backgroundColor: let bgColor, tintColor: let iconTintColor):
                settingsRowIconStyle(backgroundColor: bgColor)
                Image(systemName: name)
                    .foregroundColor(iconTintColor)
            case .customImage(iconName: let name, backgroundColor: let backgroundColor, paddingInset: let paddingInset):
                
                settingsRowIconStyle(backgroundColor: Color.white)
                
                Image(name)
            }
        }
    }
}

extension View {
    func settingsRowIconStyle(backgroundColor: Color) -> some View {
        
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(backgroundColor)
              .frame(width: 40, height: 40)
    }
}
