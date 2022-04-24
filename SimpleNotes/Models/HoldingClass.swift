//
//  HoldingClass.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/24/22.
//

import UIKit
import SwiftyDropbox

class HoldingClass {

    private lazy var googleInteractor: GoogleInteractor = GoogleInteractor()
        private lazy var dropboxInteractor: DropboxInteractor = DropboxInteractor()
    
    var currentNote: Note?
    
    var currentLocation: APIInteractor {
        if location == .dropbox {
            return self.dropboxInteractor
        } else if location == .googledrive {
            return self.googleInteractor
        }
        
        return self.googleInteractor
    }
    
    private var location: SharingLocation?

}
