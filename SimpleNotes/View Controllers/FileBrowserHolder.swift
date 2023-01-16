//
//  FileBrowserHolder.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/14/23.
//

import SwiftUI

struct FileBrowserHolder: View {
    @State var location: SharingLocation?
    @Binding var currentfolder: String?
    var serviceType: CloudType?
    
    var body: some View {
        NavigationView {
            FolderLocationViewController(location: location, currentfolder: $currentfolder, serviceType: serviceType)

       }
    }
}
