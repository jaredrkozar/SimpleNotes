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
        
        colorcollectionView = ColorCollectionView(frame: .zero)
    
        view.addSubview(colorcollectionView!)
        colorcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        colorcollectionView!.delegate = self
        // Register cell classes

        // Do any additional setup after loading the view.
     
        colorcollectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10 ).isActive = true
        colorcollectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        colorcollectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        colorcollectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        colorcollectionView?.selectedColor = { color in
            
            self.view.tintColor = UIColor(hex: color)
 
            UserDefaults.standard.set(color, forKey: "tintColor")
           
            NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        }
    }
}
