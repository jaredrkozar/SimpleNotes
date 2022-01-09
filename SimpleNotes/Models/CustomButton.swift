//
//  CustomButton.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit

class CustomButton: UIButton {
    override func draw(_ rect: CGRect) {
        #if !targetEnvironment(macCatalyst)
            self.layer.masksToBounds = true
            self.layer.cornerCurve = .continuous
            self.layer.cornerRadius = 7.0
        self.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
            self.setTitleColor(.white, for: .normal)
        #endif
    }
}
