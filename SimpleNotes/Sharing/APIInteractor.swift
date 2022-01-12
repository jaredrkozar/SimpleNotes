//
//  SignInProtocol.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

protocol APIInteractor {
    
    func signIn(from: AnyObject)
    
    var isSignedIn: Bool {get}
    
    func signOut()
}
