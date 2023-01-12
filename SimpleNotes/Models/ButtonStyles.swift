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
