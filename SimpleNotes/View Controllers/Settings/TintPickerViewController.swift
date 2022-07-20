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
        print(self.navigationController?.preferredContentSize)
        print(self.parent?.navigationController?.preferredContentSize)
        print(self.presentingViewController?.navigationController?.preferredContentSize)
        title = "Tint Picker"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        colorcollectionView = ColorCollectionView(frame: .zero)
    
        view.addSubview(colorcollectionView!)
        colorcollectionView?.translatesAutoresizingMaskIntoConstraints = false
        colorcollectionView!.delegate = self
        // Register cell classes

        // Do any additional setup after loading the view.
     
        NSLayoutConstraint.activate([
            colorcollectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorcollectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorcollectionView!.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        colorcollectionView?.selectedColor = { color in
            
            self.view.tintColor = UIColor(hex: color)
            UserDefaults.standard.set(color, forKey: "tintColor")
           
            NotificationCenter.default.post(name: Notification.Name( "tintColorChanged"), object: nil)
        }
    }
}
