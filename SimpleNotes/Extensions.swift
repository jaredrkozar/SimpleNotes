//
//  Extensions.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/18/21.
//

import UIKit
import CoreData

var notes = [Note]()
var tags: [Tag] = []
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

extension UIImage {
    func convertToData() -> String {
        let imageData = self.jpegData(compressionQuality: 1)
        let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        return imageStr
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}


func save(name: String, symbol: String) {
  
    let newTag = Tag(context: context)
    newTag.symbol = symbol
    newTag.name = name
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a tag.")
    }
}
