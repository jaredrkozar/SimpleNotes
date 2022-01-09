//
//  NoteShareSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit

class NoteShareSettingsViewController: UIViewController {

    @IBOutlet var sendNoteButton: CustomButton!
    
    var sharingLocation: SharingLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        sendNoteButton.setTitle(sharingLocation?.buttonMessage, for: .normal)
        title = sharingLocation?.viewTitle
    
        view.backgroundColor = UIColor.systemBackground
    }
}
