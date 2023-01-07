//
//  TextCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/4/23.
//

import SwiftUI

struct TextCell: View {
    @Binding var currentText: String
    @State var placeholder: String
    @State var leftText: String
    
    var body: some View {
        HStack {
            Text(leftText)
            
            TextField(placeholder, text: $currentText)
                .multilineTextAlignment(.trailing)
        }
    }
}
