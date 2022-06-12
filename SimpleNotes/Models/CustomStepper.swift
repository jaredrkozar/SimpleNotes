//
//  CustomStepper.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 6/2/22.
//

import UIKit

class CustomStepper: UIControl {

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .label
        button.addTarget(self, action: #selector(heldLeftButton), for: .touchDown)
        return button
    }()

    @objc func heldLeftButton(sender: UIButton)
}
