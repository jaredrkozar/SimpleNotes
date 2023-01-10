//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import SwiftUI

struct FolderLocationViewController: View {
    @State var location: SharingLocation?
    @Binding var currentfolder: String?
    @State private var allFiles = [CloudServiceFiles]()
    var serviceType: CloudType?
    @State private var presentAlert: Bool = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            List(allFiles) { item in
                NavigationLink(destination: FolderLocationViewController(location: location, currentfolder: .constant(item.folderID), serviceType: serviceType)) {
                   
                    IconCell(iconName: Icon(icon: item.type?.icon, iconBGColor: Color.primary, iconTintColor: Color(uiColor: item.type!.tintColor)), title: item.name ?? "Name not found")
                }
                .disabled(serviceType == .upload && item.type != .folder)
            }
            .navigationBarTitle(currentfolder ?? location!.viewTitle, displayMode: .inline)
            .toolbar {
                 Button("Select Folder") {
                     dismiss()
                 }
             }
        }
        
       
        .onAppear {
            location?.currentLocation.fetchFiles(folderID: (currentfolder ?? location?.currentLocation.defaultFolder)!, onCompleted: {
                (files, error) in
                
                guard error == nil else {
                    self.errorMessage = error?.localizedDescription
                    self.presentAlert = true
                    return
                }
                print(files?.count)
                allFiles = files!
                
            })
        }
        
        .alert(isPresented: $presentAlert) {
            Alert(title: Text(errorMessage!), message: nil, dismissButton: nil)
        }
    }
}
