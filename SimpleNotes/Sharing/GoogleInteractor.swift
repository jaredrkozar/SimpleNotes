//
//  GoogleInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit
import GoogleSignIn

class GoogleInteractor: NSObject, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Already signed in")
    }
    
    func signInSliently(vc: UIViewController) {
        GIDSignIn.sharedInstance().clientID = "968933311910-9e4an07ni7ugfji5i8t6cfkj18h1861m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = vc as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance().restorePreviousSignIn()
        print("restore previous sign in")
    }
    
    
    func signIn(vc: UIViewController) {
        GIDSignIn.sharedInstance().clientID = "968933311910-9e4an07ni7ugfji5i8t6cfkj18h1861m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = vc as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = vc
        GIDSignIn.sharedInstance().signIn()
    }
    
    var isSignedIn: Bool = false

    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    override init() {
        super.init()
    }
}
