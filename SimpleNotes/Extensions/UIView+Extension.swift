//
//  UIView+Extension.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 10/6/22.
//

import UIKit

extension UIView {

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func moveBy(x: CGFloat, y: CGFloat)
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x + x, y: self.frame.origin.y + y)
    }

    
    func createPDF() -> NSMutableData
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil)
        UIGraphicsBeginPDFPage()

        let pdfContext = UIGraphicsGetCurrentContext()!

        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        return pdfData
    }
    
    func createImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
    }
}

func createTempDirectory() -> URL? {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let dir = documentDirectory.appendingPathComponent("temp-dir-\(UUID().uuidString)")
        do {
            try FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
        return dir
    } else {
        return nil
    }
}
