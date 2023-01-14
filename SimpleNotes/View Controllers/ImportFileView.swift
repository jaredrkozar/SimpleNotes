//
//  ImportFileView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/10/23.
//

import SwiftUI
import PDFKit

struct ImportFileView: View {
    @State private var imageFromPDF: Image?
    
    var fileData: String?
    
    var title: String?
    
    @State var pdfData: Data?
    @State var pageAsThumbnail: Data?
    var location: SharingLocation
    
    private var firstPageImage: Data? {
        if pdfData != nil {
            let pdf = PDFDocument(data: pdfData!)
            let firstPage = pdf?.page(at: 0)
            let pageAsThumbnail = firstPage?.createThumbnail()
            return pageAsThumbnail
        }
        return nil
    }
    var body: some View {
        VStack {
            
            if firstPageImage == nil {
                ProgressView()
            } else {
                Image(uiImage: UIImage(data: firstPageImage!)!)
            }
            
            Text(title!)
                .font(.title)
            
            Button(action: {
                createNewNote(thumbnail: pageAsThumbnail!, pdf: pdfData!, title: title)
            }) {
                Text("Create New Note")
            }
            
            .frame(width: 600, height: 100)
            .buttonStyle(BaseButtonStyle())
        }
        
        .onAppear {
            location.currentLocation.downloadFile(identifier: fileData!, folderID: fileData, onCompleted: {
                file, error in
                guard error == nil else {
                    print("Errro")
                    return
                }
                
                pdfData = file!
            })
        }
    }
}
