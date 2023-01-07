//
//  IconCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/3/23.
//

import SwiftUI

struct IconCell: View {
    var iconName: Icon
    var title: String
    var view: AnyView
    
    var body: some View {
        NavigationLink(
            destination: view
        ) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                          .fill(.red)
                          .frame(width: 40, height: 40)
                    
                    Image(systemName: iconName.icon!)
                }
                
                Text(title)
            }
        }
    }
}

struct IconCell_Previews: PreviewProvider {
    static var previews: some View {
        IconCell(iconName: Icon(icon: "photo", iconBGColor: Color.red, iconTintColor: Color.white), title: "Picture", view: AnyView(DefaultNoteSettings()))
    }
}
