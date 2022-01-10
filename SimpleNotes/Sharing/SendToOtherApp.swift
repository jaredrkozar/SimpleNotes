//
//  SendToOtherApp.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/9/22.
//

import UIKit

extension NoteShareSettingsViewController {
    func sendToOtherApps(noteTitle: String, noteText: String?, notePDF: Data?) {
        
        
        let items = ["Title: \(noteTitle). Text: \(noteText)."]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
}
