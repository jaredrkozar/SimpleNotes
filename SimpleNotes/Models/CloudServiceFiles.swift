//
//  CloudServiceFiles.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/22/22.
//

import UIKit

struct CloudServiceFiles: Identifiable, Hashable {
    let id = UUID()
    
    var name: String?
    var type: MimeTypes?
    var folderID: String?
}
