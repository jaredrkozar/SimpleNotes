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
    
    var iconName: Icon
    var title: String
    var view: AnyView?
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconName.iconBGColor ?? Color(uiColor: UIColor.systemBackground))
                      .frame(width: 40, height: 40)
                
                Image(systemName: iconName.icon!).foregroundColor(iconName.iconTintColor)
            }
            
            Text(title)
        }
    }
}

struct IconCell_Previews: PreviewProvider {
    static var previews: some View {
        IconCell(iconName: Icon(icon: "photo", iconBGColor: Color.red, iconTintColor: Color.white), title: "Picture", view: AnyView(DefaultNoteSettings()))
    }
}
