//
//  AlertController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/22/22.
//

import UIKit

class CustomAlert {
    static func showAlert(title: String?, message: String?) {
        let firstWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        firstWindow?.present(ac, animated: true, completion: nil)
    }
}
