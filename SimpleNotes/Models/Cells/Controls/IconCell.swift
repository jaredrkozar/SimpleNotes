//
//  IconCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct IconCell: View, Hashable, Identifiable {
    
    let id = UUID()
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: IconCell, rhs: IconCell) -> Bool {
        return lhs.id == rhs.id
    }
    
    var icon: RoundedIcon?
    var title: String
    var view: AnyView?
    
    var body: some View {
        HStack {
            icon
            Text(title)
        }
    }
}

struct IconCell_Previews: PreviewProvider {
    static var previews: some View {
        IconCell(icon: RoundedIcon(icon: .systemImage(iconName: "dpc", backgroundColor: Color.red, tintColor: .white)), title: "Hello")
    }
}
