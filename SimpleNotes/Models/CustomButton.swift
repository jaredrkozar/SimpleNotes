//
//  CustomButton.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/19/22.
//

import UIKit

import UIKit

class CustomButton: UIButton {
    override func draw(_ rect: CGRect) {
        #if !targetEnvironment(macCatalyst)
            self.layer.masksToBounds = true
            self.layer.cornerCurve = .continuous
            self.layer.cornerRadius = 7.0
        self.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        self.titleLabel?.textColor = UIColor.white
            self.setTitleColor(.white, for: .normal)
        #endif
    }
}
