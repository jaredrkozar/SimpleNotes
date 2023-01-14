//
//  PickerCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/8/23.
//

import SwiftUI

struct PickerCell: View {
    var icon: RoundedIcon?
    @State var title: String
    @State var options: [String]
    @Binding var selected: String
    
    var body: some View {
        HStack {
            icon
        
            Picker(title, selection: $selected) {                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
        }
    }
}

struct PickerCell_Previews: PreviewProvider {
    @State static var sample: String = ""
    
    static var previews: some View {
        PickerCell(title: "Sample picker", options: ["Option 1", "Option 2", "Option 3"], selected: $sample)
    }
}
