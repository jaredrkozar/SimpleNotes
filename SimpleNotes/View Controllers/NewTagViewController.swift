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
    var image: String?
    var color: UIColor?
    var name: String?
    
    var imageIndex: Int?
    var colorIndex: Int?
    
    let details = [[UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor(named: "Red")], ["folder", "tray", "externaldrive", "doc", "doc.plaintext", "note.text", "book", "book.closed", "ticket", "link", "person", "person.crop.circle", "person.crop.square", "sun.max", "moon", "umbrella", "thermometer", "cloud.moon", "mic", "loupe", "magnifyingglass", "square", "circle", "eye", "tshirt", "eyeglasses", "facemask", "message", "bubble.right", "quote.bubble", "star.bubble", "exclamationmark.bubble", "plus.bubble", "checkmark.bubble"]]
      
    
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
        
        tagNameField.text = name
        symbolImage.image = sendBackSymbol(imageName: image ?? "folder", color: color ?? UIColor.systemBlue)
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
            cell.detailImageView.backgroundColor = details[0][indexPath.item] as? UIColor
        } else {
            cell.detailImageView.image =  sendBackSymbol(imageName: details[1][indexPath.item] as! String, color: UIColor.systemGray)
        }
           
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            colorIndex = indexPath.item
            color = details[0][indexPath.item] as! UIColor
        } else {
            imageIndex = indexPath.item
            image = details[1][indexPath.item] as! String
        }
        
        symbolImage.image = sendBackSymbol(imageName: (image ?? "folder"), color: color ?? UIColor.systemGray)
    }

    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        print(details[0][colorIndex ?? 2])
        print(details[1][imageIndex ?? 0])
        
        saveTag(name: tagNameField.text!, symbol: details[1][imageIndex ?? 0] as! String, color: (color?.toHex)!)
        dismiss(animated: true, completion: nil)
    }
}
