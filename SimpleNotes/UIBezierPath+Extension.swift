//
//  UIBezierPath+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import UIKit
import Foundation

extension UIBezierPath {
    func data() throws -> Data {
      let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
      return data
    }
    
    static func from(data: Data) throws -> UIBezierPath {
        guard let bezierPath = try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: data) else { return UIBezierPath() }
      
      return bezierPath
    }
}
