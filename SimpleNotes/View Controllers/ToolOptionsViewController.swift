//
//  ToolOptionsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 5/11/22.
//

import UIKit

class ToolOptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var layout: UICollectionViewFlowLayout {
        let cellLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        cellLayout.itemSize = CGSize(width: 50, height: 50)
        cellLayout.scrollDirection = .vertical
        return cellLayout
    }
    
    var colorCollectionView: UICollectionView?
    var sizeCollectionView: UICollectionView?
    var lineTypeCollectionView: UICollectionView?
    
    var drawingview: DrawingView?
    
    var colors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemCyan, UIColor.systemPurple, UIColor.systemIndigo, UIColor.systemPink, UIColor(named: "Red")]

    var sizes = [1.0, 3.0, 5.0, 7.0, 10.0, 13.0, 15.0, 17.0, 21.0, 25.0]
    
    var lineTypes = [["normalLine", "Normal"], ["dashedLine", "Dashed"], ["dottedLine", "Dotted"]]
    
    override func viewDidLoad() {
        
        title = "Pen Settings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(toggleFavoriteTool))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .vertical
        colorCollectionView?.backgroundColor = .gray
        if currentDevice == .iphone {
            
            colorCollectionView = UICollectionView(frame: CGRect(x: 10, y: 60, width: Constants.screenWidth - 15, height: 300), collectionViewLayout: layout)

            
        }
        let colorcell = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        colorCollectionView!.register(colorcell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        view.addSubview(colorCollectionView!)
        colorCollectionView!.allowsSelection = true
        colorCollectionView?.allowsMultipleSelection = false
        
        sizeCollectionView?.backgroundColor = .gray
        if currentDevice == .iphone {
            
            sizeCollectionView = UICollectionView(frame: CGRect(x: 10, y: 200, width: Constants.screenWidth - 20, height: 300), collectionViewLayout: layout)
            
        }
        
        let sizecell = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        sizeCollectionView!.register(sizecell, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        view.addSubview(sizeCollectionView!)
       
        sizeCollectionView!.allowsSelection = true
        sizeCollectionView?.allowsMultipleSelection = false
        
        lineTypeCollectionView?.backgroundColor = .gray
        let lineTypeLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        lineTypeLayout.itemSize = CGSize(width: 210, height: 90)
        lineTypeLayout.scrollDirection = .horizontal
        if currentDevice == .iphone {
            
            lineTypeCollectionView = UICollectionView(frame: CGRect(x: 5, y: 320, width: Constants.screenWidth, height: 90), collectionViewLayout: lineTypeLayout)
            
        }
        
        let lineCell = UINib(nibName: "LineTypeCollectionViewCell", bundle: nil)
        lineTypeCollectionView!.register(lineCell, forCellWithReuseIdentifier: "LineTypeCollectionViewCell")
        view.addSubview(lineTypeCollectionView!)
       
        lineTypeCollectionView!.allowsSelection = true
        lineTypeCollectionView?.allowsMultipleSelection = false
        
        colorCollectionView?.delegate = self
        colorCollectionView?.dataSource = self
        sizeCollectionView!.delegate = self
        sizeCollectionView!.dataSource = self
        lineTypeCollectionView?.delegate = self
        lineTypeCollectionView?.dataSource = self
        
    }
    
    @objc func toggleFavoriteTool(sender: UIBarButtonItem) {
        
        sender.image = UIImage(systemName: "star.fill")
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
            let cell = colorCollectionView?.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            
            cell.backgroundColor = colors[indexPath.item]
            cell.layer.cornerRadius = Constants.cornerRadius
            return cell
        } else if(collectionView == sizeCollectionView) {
            let cell = sizeCollectionView?.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            
            let circle = CAShapeLayer()
            circle.fillColor = UIColor.label.cgColor
            circle.path = UIBezierPath(arcCenter: CGPoint(x: cell.bounds.size.width * 0.5, y: cell.bounds.size.width * 0.5), radius: sizes[indexPath.item] * 0.75, startAngle: 0.0, endAngle: .pi * 2, clockwise: true).cgPath
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.backgroundColor = .systemGray5
            cell.layer.addSublayer(circle)
   
            return cell
        }  else if(collectionView == lineTypeCollectionView){
            let cell = lineTypeCollectionView?.dequeueReusableCell(withReuseIdentifier: "LineTypeCollectionViewCell", for: indexPath) as! LineTypeCollectionViewCell
            cell.backgroundColor = .systemGray5
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.lineImage.image = UIImage(named: lineTypes[indexPath.item][0])
            cell.lineName.text = lineTypes[indexPath.item][1]
            return cell
        } else {
            let cell = lineTypeCollectionView?.dequeueReusableCell(withReuseIdentifier: "lineTypeCell", for: indexPath) as! LineTypeCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == colorCollectionView) {
            if let cell = colorCollectionView?.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                cell.layer.borderColor = colors[indexPath.item]?.darker(by: 40.0)?.cgColor
                cell.layer.borderWidth = Constants.borderWidth
                }
            
            UserDefaults.standard.set(colors[indexPath.item]?.toHex, forKey: "changedColor")
            NotificationCenter.default.post(name: Notification.Name( "changedColor"), object: nil)
        } else if(collectionView == sizeCollectionView) {

            if let cell = sizeCollectionView!.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                cell.layer.borderColor = UIColor.gray.cgColor
                cell.layer.borderWidth = Constants.borderWidth
                }
            
            UserDefaults.standard.set(sizes[indexPath.item], forKey: "changedWidth")
            NotificationCenter.default.post(name: Notification.Name( "changedWidth"), object: nil)
        }  else if(collectionView == lineTypeCollectionView){
            if let cell = collectionView.cellForItem(at: indexPath) as? LineTypeCollectionViewCell {
                cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.35)
                cell.layer.borderColor = UIColor.systemBlue.darker(by: 10.0)?.cgColor
                cell.layer.borderWidth = Constants.borderWidth
                }

            
            
            if(indexPath.item==0) {
                UserDefaults.standard.set(StrokeTypes.normal.rawValue, forKey: "changedStrokeType")
            } else if indexPath.item==1 {
                UserDefaults.standard.set(StrokeTypes.dashed.rawValue, forKey: "changedStrokeType")
                
            } else if indexPath.item==2 {
                UserDefaults.standard.set(StrokeTypes.dotted.rawValue, forKey: "changedStrokeType")
            }
            
            NotificationCenter.default.post(name: Notification.Name( "changedStrokeType"), object: nil)
            
        } else {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == colorCollectionView) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                cell.layer.borderWidth = 0.0
                }
        } else if(collectionView == sizeCollectionView) {

            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                cell.backgroundColor = UIColor.systemGray5
                cell.layer.borderWidth = 0.0
                }
        }  else if(collectionView == lineTypeCollectionView){
            if let cell = collectionView.cellForItem(at: indexPath) as? LineTypeCollectionViewCell {
                cell.backgroundColor = UIColor.systemGray5
                cell.layer.borderWidth = 0.0
                }
        } else {
            return
        }
    }
}
