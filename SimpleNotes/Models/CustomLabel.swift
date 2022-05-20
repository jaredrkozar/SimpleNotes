//
//  CustomLabel.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/19/22.
//

import UIKit

class CustomLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        self.textColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
