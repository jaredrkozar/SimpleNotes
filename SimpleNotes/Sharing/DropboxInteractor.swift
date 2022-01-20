//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: DropboxClient, APIInteractor {
    
    func signIn(vc: UIViewController) {
        print("DD")
    }
    
    var isSignedIn: Bool = false
    
    func signOut() {
        print("DKD")
    }
    


}
