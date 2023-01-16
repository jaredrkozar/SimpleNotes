//
//  NoteShareSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import SwiftUI
import GoogleSignIn

struct NoteShareSettingsViewController: View {
    
    var getNoteData: ((_ exportType: SharingType)->(Data))?
    @State var typeIndex: Int = 0
    
    @State var imageType: String = "PNG"
    @State var format: SharingType?
    var currentNoteTitle: String?
    var sharingLocation: SharingLocation?
    
    @State var folderID: String?
    @State private var showingExporter = false
    @State private var showingSheet = false
    
    var body: some View {
        HStack {
                
            ForEach(Array(SharingType.allCases.enumerated()), id: \.element) { index, type in
                ShareCell(type: type, index: index, currentValue: $typeIndex) { type in
                    
                    format = type
                }
            }
        }
        
        List {
            if format == .image {
                PickerCell(title: "Image Type", options: ["PNG", "JPEG"], selected: $imageType)
            }
            
            IconCell(icon: RoundedIcon(icon: .systemImage(iconName: "cloud", backgroundColor: .blue, tintColor: .white)), title: "Folders")
                .onTapGesture {
                    showingSheet = true
                }
                .sheet(isPresented: $showingSheet) {
                    FileBrowserHolder(location: sharingLocation, currentfolder: $folderID, serviceType: .upload)
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "removeViewNotification"))) { _ in
                    print(folderID)
                }
        }
        
        Button {
            shareNote()
        } label: {
            Text(sharingLocation!.buttonMessage)
                .frame(maxWidth: .infinity)

        }
        .padding(20)
        .buttonStyle(.borderedProminent)
        
        .navigationTitle(sharingLocation!.viewTitle)
    }
    
    func shareNote() {
        print(folderID)
    }
}


private struct ShareCell: View {
    @State var type: SharingType
    @State var index: Int
    @Binding var currentValue: Int
    @State var tappedAction: ((SharingType) -> Void)
 
    var body: some View {
        Button(action: {
            currentValue = index
            tappedAction(type)
        }) {
            ZStack {
                VStack {
                    type.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.top], 10)
                        .frame(width: 60, height: 60)
                        .padding([.bottom], 10)
                    
                    Text(type.name)
                        .frame(width: 80, height: 60)
                        .foregroundColor(Color.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .contentShape(Rectangle())
        }
        .frame(width: 100, height: 130, alignment: .center)
        
        .background(index == currentValue ? type.color : Color(uiColor: .secondarySystemBackground))
        .buttonStyle(PlainButtonStyle())
        .cornerRadius(15)
        .padding(10)
    }
}

