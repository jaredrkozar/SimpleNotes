//
//  ImageListCell.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/8/23.
//

import SwiftUI

struct ImagePickerCell: View {
    @State var images = [ImageCell]()
    @Binding var cellTapped: Int
    @State var tappedAction: ((Int) -> Void)
    
    let gridlayout = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                LazyVGrid(columns: gridlayout , spacing: 10) {
                    ForEach(Array(images.enumerated()), id: \.element) { index, image in
                    
                        ImageListCell(image: image.image, text: image.text, index: index, currentValue: $cellTapped, tappedAction: tappedAction)
                    }
               }
               .padding(.horizontal)
            }
        }
    }
}

private struct ImageListCell: View {
    @State var image: Image
    @State var text: String
    @State var index: Int
    @Binding var currentValue: Int
    @State var tappedAction: ((Int) -> Void)
    
    var body: some View {
        Button(action: {
            currentValue = index
            tappedAction(currentValue)
        }) {
            ZStack {
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.top], 10)
                        .frame(width: 50, height: 50)
                    
                    
                    Text(text)
                        .frame(width: 80, height: 60)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: index == currentValue ? "checkmark.circle.fill" : "circle")
                        .padding([.bottom], 10)
                }
            }
            .contentShape(Rectangle())
        }
        .frame(width: 100, alignment: .center)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .quaternarySystemFill))
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(15)
    }
}

struct ImageCell: Identifiable, Hashable {
    let id = UUID()
    var image: Image
    var text: String
    
    public static func == (lhs: ImageCell, rhs: ImageCell) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
