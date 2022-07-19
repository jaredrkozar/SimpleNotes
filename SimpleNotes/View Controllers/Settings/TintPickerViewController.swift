//
//  TintPickerViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/22/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class TintPickerViewController: UIViewController, UICollectionViewDelegate {

    private var colorcollectionView: ColorCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Tint Picker"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        colorcollectionView = ColorCollectionView(frame: CGRect(x: 20, y: 30, width: view.bounds.width, height: 400))
    
        view.addSubview(colorcollectionView!)
        colorcollectionView!.delegate = self
        // Register cell classes

        // Do any additional setup after loading the view.
     
        colorcollectionView?.selectedColor = { color in
            print(color)
            self.view.tintColor = UIColor(hex: color)
            UserDefaults.standard.set(color, forKey: "tintColor")
           
            NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        }
    }
}
