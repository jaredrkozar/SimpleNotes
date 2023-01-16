//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import SwiftUI

struct FolderLocationViewController: View {
    let location: SharingLocation?
    @Binding var currentfolder: String?
    @State var allFiles = [CloudServiceFiles]()
    let serviceType: CloudType?
    @State var errorMessage: String = ""
    
    var body: some View {
        List(allFiles, id: \.self) { item in
            NavigationLink(destination: chooseDestination(item: item)
            ) {
                IconCell(icon: RoundedIcon(icon: .systemImage(iconName: item.type?.icon ?? "exclamationmark.triangle", backgroundColor:  Color(uiColor: item.type!.tintColor), tintColor: Color.white)), title: item.name ?? "Name not found", view: nil)
            }
            .disabled(serviceType == .upload && item.type != .folder)
        }
        .navigationTitle(currentfolder?.components(separatedBy: "/").last ?? location!.viewTitle)
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if serviceType == .upload {
                    Button("Select Folder") {
                        currentfolder = "HEELO"
                        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "removeViewNotification")))
                    }
                }
            }
        }
        .onAppear {
                   location?.currentLocation.fetchFiles(folderID: (currentfolder ?? location?.currentLocation.defaultFolder)!, onCompleted: {
                       (files, error) in
                       
                       guard error == nil else {
                           self.errorMessage = error!.localizedDescription
                           return
                       }
                    
                       allFiles = files!
                       
                   })
               }
    }
    
    func getDataForFile(fileID: String, userCompletionHandler: @escaping (Data) -> Void) {
        
        location?.currentLocation.downloadFile(identifier: fileID, folderID: fileID, onCompleted: {file, error in
            
            userCompletionHandler(file!)
        })
    }
    
    @ViewBuilder
    func chooseDestination(item: CloudServiceFiles) -> some View {
        if item.type == .pdf && serviceType == .download {
            Text("DLLD")
        } else {
            FolderLocationViewController(location: location, currentfolder: .constant(item.folderID), serviceType: serviceType)
        }
     }
}
