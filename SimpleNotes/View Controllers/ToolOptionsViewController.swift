//
//  ToolOptionsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/11/22.
//

import UIKit

class ToolOptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var colorCollectionView: UICollectionView!
    
    @IBOutlet var sizeCollectionView: UICollectionView!
    
    @IBOutlet var lineTypeCollectionView: UICollectionView!
    
    var drawingview: DrawingView?
    
    var colors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor(named: "Red")]

    var sizes = [1.0, 3.0, 5.0, 7.0, 10.0, 13.0, 15.0, 17.0, 21.0, 25.0]
    
    var lineTypes = [["normalLine", "Normal"], ["dashedLine", "Dashed"], ["dottedLine", "Dotted"]]
    
    override func viewDidLoad() {
        
        let nib = UINib(nibName: "LineTypeCollectionViewCell", bundle: nil)
        lineTypeCollectionView.register(nib, forCellWithReuseIdentifier: "lineTypeCell")
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        lineTypeCollectionView.delegate = self
        lineTypeCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == colorCollectionView) {
            return colors.count
        } else if(collectionView == sizeCollectionView){
            return sizes.count
        } else {
            return lineTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == colorCollectionView) {
            let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
            
            cell.backgroundColor = colors[indexPath.item]
            cell.layer.cornerRadius = 9.0
            return cell
        } else if(collectionView == sizeCollectionView) {
            let cell = sizeCollectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! ColorCollectionViewCell
            
            let circle = CAShapeLayer()
           
            circle.path = UIBezierPath(arcCenter: CGPoint(x: cell.bounds.size.width * 0.5, y: cell.bounds.size.width * 0.5), radius: sizes[indexPath.item], startAngle: 0.0, endAngle: .pi * 2, clockwise: true).cgPath
   
            cell.layer.addSublayer(circle)
            cell.backgroundColor = .gray
   
            return cell
        }  else if(collectionView == lineTypeCollectionView){
            let cell = lineTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "lineTypeCell", for: indexPath) as! LineTypeCollectionViewCell
            cell.backgroundColor = .systemGray5
            cell.layer.cornerRadius = 10.0
            cell.lineImage.image = UIImage(named: lineTypes[indexPath.item][0])
            cell.lineName.text = lineTypes[indexPath.item][1]
            return cell
        } else {
            let cell = lineTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "lineTypeCell", for: indexPath) as! LineTypeCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == colorCollectionView) {
            UserDefaults.standard.set(colors[indexPath.item]?.toHex, forKey: "changedColor")
            NotificationCenter.default.post(name: Notification.Name( "changedColor"), object: nil)
        } else if(collectionView == sizeCollectionView) {

            UserDefaults.standard.set(sizes[indexPath.item], forKey: "changedWidth")
            NotificationCenter.default.post(name: Notification.Name( "changedWidth"), object: nil)
        }  else if(collectionView == lineTypeCollectionView){
            print(indexPath.item)
            if(indexPath.item==0) {
                UserDefaults.standard.set(StrokeTypes.normal.rawValue, forKey: "changedStrokeType")
            } else if indexPath.item==1 {
                UserDefaults.standard.set(StrokeTypes.dotted.rawValue, forKey: "changedStrokeType")
                
            } else if indexPath.item==1 {
                UserDefaults.standard.set(StrokeTypes.dashed.rawValue, forKey: "changedStrokeType")
            }
            
            NotificationCenter.default.post(name: Notification.Name( "changedStrokeType"), object: nil)
            
        } else {
            return
        }
    }
}
