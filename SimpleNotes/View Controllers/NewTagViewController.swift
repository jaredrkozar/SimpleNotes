//
//  NewTagViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/20/21.
//

import UIKit

class NewTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let detailIcons = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
    
    @IBOutlet var tagNameField: UITextField!
    @IBOutlet var symbolImage: UIImageView!
    @IBOutlet var detailsView: UICollectionView!
    var currentTag: AllTags?
    var colorCell = "colorCell"
    var iconCell = "iconCell"
    
    var image: String?
    var color: UIColor?
    var name: String?

    var isEditingTag: Bool?
    
    let details = [[UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor(named: "Red")], ["folder", "tray", "externaldrive", "doc", "doc.plaintext", "note.text", "book", "book.closed", "ticket", "link", "person", "person.crop.circle", "person.crop.square", "sun.max", "moon", "umbrella", "thermometer", "cloud.moon", "mic", "loupe", "magnifyingglass", "square", "circle", "eye", "tshirt", "eyeglasses", "facemask", "message", "bubble.right", "quote.bubble", "star.bubble", "exclamationmark.bubble", "plus.bubble", "checkmark.bubble"]]
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "DetailCollectionViewCell", bundle: nil)
        detailsView.register(nib, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
        let colorCell = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        detailsView.register(colorCell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        detailsView.delegate = self
        detailsView.dataSource = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.rightBarButtonItems = [doneButton]
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        tagNameField.text = name
        symbolImage.image = sendBackSymbol(imageName: image ?? "folder", color: color ?? UIColor.systemBlue)
        
        detailsView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: CollectionReusableView.identifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = detailsView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            cell.layer.cornerRadius = 12.0
            cell.backgroundColor = details[0][indexPath.item] as? UIColor
            
            return cell
        } else {
            let cell = detailsView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell

            cell.detailImageView.image =  sendBackSymbol(imageName: details[1][indexPath.item] as! String, color: UIColor.systemGray)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            color = details[0][indexPath.item] as! UIColor
        } else {
            image = details[1][indexPath.item] as! String
        }
        
        symbolImage.image = sendBackSymbol(imageName: (image ?? "folder"), color: color ?? UIColor.systemGray)
    }

    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        if isEditingTag == true {
            saveTag(currentTag: currentTag, name: tagNameField.text!, symbol: image!, color: (color?.toHex)!)
        } else {
            saveTag(currentTag: nil, name: tagNameField.text!, symbol: image!, color: (color?.toHex)!)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? CollectionReusableView
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            
            if indexPath.section == 1 {
                header.label.text = " Dark icons"
            } else {
                header.label.text = " Light icons"
            }
        
        return header
    }
}
