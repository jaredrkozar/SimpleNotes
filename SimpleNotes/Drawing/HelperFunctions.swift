//
//  HelperFunctions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 4/30/22.
//

import UIKit


class HelperFunctions: NSObject, UIGestureRecognizerDelegate {
    static func resizeLowerRight(view: UIView, translation: CGPoint, start: CGPoint) {
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.bounds.width + translation.x - start.x, height: view.bounds.height + translation.y - start.y)
    }
    
    static func resizeLowerLeft(view: UIView, translation: CGPoint, start: CGPoint) {
        view.frame = CGRect(x: view.frame.origin.x + translation.x - start.x, y:  view.frame.origin.y, width: view.frame.size.width - translation.x + start.x, height: view.frame.size.height + translation.y - start.y)
                
        
    }
    
    static func resizeUpperRight(view: UIView, translation: CGPoint, start: CGPoint) {
        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + translation.y - start.y, width: view.bounds.width + translation.x - start.x, height: view.bounds.height - translation.y + start.y)
    }
    
    static func resizeUpperLeft(view: UIView, translation: CGPoint, start: CGPoint) {
        view.frame = CGRect(x: view.frame.origin.x + translation.x - start.x, y:  view.frame.origin.y + translation.y - start.y, width: view.frame.size.width - translation.x + start.x, height: view.frame.size.height - translation.y + start.y)
        
    }
}
