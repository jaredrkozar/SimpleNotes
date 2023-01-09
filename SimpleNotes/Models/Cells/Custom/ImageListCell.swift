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
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Array(images.enumerated()), id: \.element) { index, image in
                    
                    ImageListCell(image: image.image, text: image.text, index: index, currentValue: $cellTapped, tappedAction: tappedAction)
                }
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
    var selectedInt: Int = 0
    
    var body: some View {
        Button(action: {
            currentValue = index
            tappedAction(currentValue)
        }) {
            ZStack {
                VStack {
                    image
                        .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    
                    
                    Text(text)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: index == currentValue ? "checkmark.circle.fill" : "circle")
                }
            }
        }
        .frame(width: 100, alignment: .center)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .quaternarySystemFill))
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(15)
        .padding(10)
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
