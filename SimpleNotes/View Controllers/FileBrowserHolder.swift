//
//  FileBrowserHolder.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/14/23.
//

import SwiftUI

struct FileBrowserHolder: View {
    @State var location: SharingLocation?
    @State var currentfolder: String?
    @State private var allFiles = [CloudServiceFiles]()
    var serviceType: CloudType?
    
    var body: some View {
        NavigationView {
            FolderLocationViewController(location: location, currentfolder: $currentfolder, serviceType: serviceType)
       }
    }
}
