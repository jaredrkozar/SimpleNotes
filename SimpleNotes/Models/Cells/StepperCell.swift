//
//  StepperCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct StepperCell: View {
    @State var minValue: Int
    @State var maxValue: Int
    @State var text: String
    @Binding var currentValue: Int
    
    var body: some View {
        Text(text)
        Stepper("", value: $currentValue, in: minValue...maxValue)
    }
}

struct StepperCell_Previews: PreviewProvider {
    @State static var font: Int = 20
    static var previews: some View {
        StepperCell(minValue: 1, maxValue: 20, text: "STEPPER", currentValue: $font)
    }
}
