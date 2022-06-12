//
//  ObjectView.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit

protocol ObjectView {
    var moveIconImage: UIImageView { get set }
    var start: CGPoint { get set }
    var isMoving: Bool { get set }
    var isResizing: Bool { get set }
    var resizingHandles: [UIButton] { get set }
    
   func isCurrentView()
    func isNotCurrentView()
}

