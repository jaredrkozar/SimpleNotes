//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class NewTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var tagNameField: UITextField!
    @IBOutlet var symbolImage: UIImageView!
    @IBOutlet var detailsView: UICollectionView!
    
    let details = [["Red", "Green", "Blue"], ["folder", "tray", "externaldrive", "doc", "doc.plaintext", "note.text", "book", "book.closed", "ticket", "link", "person", "person.crop.circle", "person.crop.square", "sun.max", "moon", "umbrella", "thermometer", "cloud.moon", "mic", "loupe", "magnifyingglass", "square", "circle", "eye", "tshirt", "eyeglasses", "facemask", "message", "bubble.right", "quote.bubble", "star.bubble", "exclamation.bubble", "plus.bubble", "checkmark.bubble"]]
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        detailsView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
        detailsView.delegate = self
        detailsView.dataSource = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        
        if indexPath.section == 0 {
            cell.detailImageView.backgroundColor = UIColor(named: details[0][indexPath.item])
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
            cell.detailImageView.image = UIImage(systemName: details[1][indexPath.item], withConfiguration: configuration)
        }
           
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            symbolImage.image = (symbolImage.image ?? UIImage(systemName: details[1][0]))? .withTintColor(UIColor(named: details[indexPath.section][indexPath.item])!, renderingMode: .alwaysOriginal)
            
            
        } else {
            let configuration = UIImage.SymbolConfiguration(pointSize: 55.0, weight: .medium, scale: .large)
            symbolImage.image = UIImage(systemName: details[indexPath.section][indexPath.item], withConfiguration: configuration)
        }
    }

    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
  
        saveTag(name: tagNameField.text!, symbol: (symbolImage.image?.convertToData())!)
        
        dismiss(animated: true, completion: nil)
    }
    
}
