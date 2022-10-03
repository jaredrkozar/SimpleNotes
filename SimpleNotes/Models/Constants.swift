//
//  Constants.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/20/22.
//

import UIKit

struct Constants {
    public static var screenWidth = UIScreen.main.bounds.width
    
    public static var cornerRadius = 10.0
    
    public static var borderWidth = 3.5
    
   public static var colors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor.systemGray5]
    
    public static var colorLayout: UICollectionViewFlowLayout {
        let cellLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        cellLayout.itemSize = CGSize(width: 50, height: 50)
        cellLayout.scrollDirection = .vertical
        return cellLayout
    }
}


