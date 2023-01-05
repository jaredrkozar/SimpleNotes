//
//  StepperCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct StepperCell: View {
    @State var text: String
    @Binding var bindingVar: Int
    
    var body: some View {
        Text(text)
        Stepper("", value: $bindingVar)
    }
}

struct StepperCell_Previews: PreviewProvider {
    @State static var font: Int = 20
    static var previews: some View {
        StepperCell(text: "Font size", bindingVar: $font)
    }
}
