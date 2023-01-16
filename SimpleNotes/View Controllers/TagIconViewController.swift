//
//  TagIconViewController.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/13/23.
//

import SwiftUI

struct TagIconViewController: View {
    let gridlayout = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        LazyHGrid(rows: gridlayout) {
            ForEach(SFSymbolsData.allSymbols, id: \.self) { section in
                Section(header: Text("Important tasks")) {
                    ForEach(section, id: \.self) { symbol in
                        Image(systemName: symbol)
                    }
                }
            }
        }
    }
}
