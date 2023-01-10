//
//  ImportFileView.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 1/10/23.
//

import SwiftUI
import PDFKit

struct ImportFileView: View {
    private var imageFromPDF: Image {
        let pdf = PDFDocument(data: pdfData)
        let firstPage = pdf?.page(at: 1)
        return Image(uiImage: UIImage(data: (firstPage?.createThumbnail())!)!)
    }
    
    var title: String?
    
    var pdfData: Data
    var body: some View {
        HStack {
            imageFromPDF
        }
    }
}
