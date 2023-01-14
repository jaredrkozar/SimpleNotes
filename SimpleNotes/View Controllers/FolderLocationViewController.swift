//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import SwiftUI

struct FolderLocationViewController: View {
    var location: SharingLocation?
    @Binding var currentfolder: String?
    @State private var allFiles = [CloudServiceFiles]()
    var serviceType: CloudType?
    var currentFolderName: String?
    @State private var presentAlert: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List(allFiles) { item in
            NavigationLink(destination: item.type == .pdf &&
                           serviceType == .download ? AnyView(Text("ELEL")) : AnyView(FolderLocationViewController(location: location, currentfolder: .constant(item.folderID), serviceType: serviceType, currentFolderName: item.name))
            ) {
                IconCell(icon: RoundedIcon(icon: .systemImage(iconName: item.type?.icon ?? "exclamationmark.triangle", backgroundColor:  Color(uiColor: item.type!.tintColor), tintColor: Color.white)), title: item.name ?? "Name not found", view: nil)
            }
            .disabled(serviceType == .upload && item.type != .folder)
        }
        .navigationTitle(currentFolderName ?? (location == .dropbox ? "Dropbox" : "Google Drive"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Select Folder") {
                    dismiss()
                }
            }
        }
        
        .onAppear {
            location?.currentLocation.fetchFiles(folderID: (currentfolder ?? location?.currentLocation.defaultFolder)!, onCompleted: {
                (files, error) in
                
                guard error == nil else {
                    self.errorMessage = error!.localizedDescription
                    self.presentAlert = true
                    return
                }
                
                allFiles = files!
                
            })
        }
        
        .alert(isPresented: $presentAlert) {
            Alert(title: Text(errorMessage), message: nil, dismissButton: nil)
        }
    }
    
    func getDataForFile(location: SharingLocation, fileID: String, userCompletionHandler: @escaping (Data) -> Void) {
        location.currentLocation.downloadFile(identifier: fileID, folderID: fileID, onCompleted: {file, error in
            
            userCompletionHandler(file!)
        })
    }
}
