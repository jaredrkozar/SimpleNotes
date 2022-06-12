//
//  LockNote.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/14/22.
//

import UIKit
import LocalAuthentication

class LockNote {
    
    func authenticate(title: String,  onCompleted: @escaping (Bool, Error?) -> ()) {
      let context = LAContext()
     
      var authError: NSError?
          if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
              context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: title) { success, error in
                  DispatchQueue.main.async {
                      return onCompleted(success, error)
              
                  }
              }
          } else {
             // Handle Error
          }
       }
}
