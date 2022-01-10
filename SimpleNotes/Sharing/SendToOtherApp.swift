//
//  SendToOtherApp.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit

extension NoteShareSettingsViewController {
    func sendToOtherApps(data: [Any]) {
        
        let ac = UIActivityViewController(activityItems: data, applicationActivities: nil)
        self.present(ac, animated: true)
    }
}
