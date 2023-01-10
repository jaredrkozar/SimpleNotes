//
//  TextStylingCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/8/23.
//

import SwiftUI

struct TextStylingCell: View {
    var body: some View {
        HStack {
            Button("Press Me") {
               print("Button pressed!")
           }
           .buttonStyle(BlueButton())
        }
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .cornerRadius(6)
            .background(Color(uiColor: .quaternarySystemFill))
            .padding(6)
    }
}


struct TextStylingCell_Previews: PreviewProvider {
    static var previews: some View {
        TextStylingCell()
    }
}
