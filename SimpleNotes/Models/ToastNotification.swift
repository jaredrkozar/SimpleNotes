//
//  AlertController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/22/22.
//

import UIKit

class ToastNotification: UIView {
  
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor.white
        image.frame = CGRect(x: 5, y: 10, width: 50, height: 50)
        image.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
        image.image = UIImage(systemName: "pin")
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.frame = CGRect(x: 65, y: 10, width: UIScreen.main.nativeBounds.width - 45, height: 40)
        return label
    }()
    
    lazy var subtitleLabel: UITextView = {
        let label = UITextView()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        
        //shouldnt call sizeToFit because it sizeToFit has increase cpu usage

        label.backgroundColor = .clear
        return label
    }()
    
    func showToast(backgroundColor: UIColor, image: UIImage, titleText: String, subtitleText: String?, progress: Double?) {
        
        let window =  UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = Constants.cornerRadius
        self.alpha = 1.0
        
        self.addSubview(imageView)
        
        titleLabel.text = titleText
        self.addSubview(titleLabel)
        
        if progress == nil {
            subtitleLabel.text = subtitleText
            let width = Constants.screenWidth - 130
            let height = subtitleLabel.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
            subtitleLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY, width: width, height: height)
            
            //have to add textview as a snapshot for some reason
            let snapshot = subtitleLabel.snapshotView(afterScreenUpdates: true)
            snapshot?.frame = subtitleLabel.frame
            self.addSubview(snapshot!)
        } else {
            let progressView = UIProgressView()
            progressView.progress = 0.35
            progressView.frame = CGRect(x: 65, y: 45, width: self.bounds.maxX - 155, height: 30)
            progressView.progressTintColor = .white
            progressView.trackTintColor = backgroundColor.darker(by: 40.0)
            self.addSubview(progressView)
            
            let cancelButton = UIButton(type: .system)
            cancelButton.backgroundColor = backgroundColor.darker(by: 40.0)
            cancelButton.frame = CGRect(x: self.bounds.maxX - 80, y: 10, width: 70, height: 50)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            cancelButton.target(forAction: #selector(cancelUpload), withSender: self)
            cancelButton.layer.cornerRadius = Constants.cornerRadius
            self.addSubview(cancelButton)
            
        }
        
        self.frame = CGRect(x: 30, y: -70, width: Constants.screenWidth - 60, height: subtitleLabel.frame.maxY + 10)

        window?.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0.4, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            
            self.transform = CGAffineTransform(translationX: 0, y: 180)
            
            
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: [.curveEaseIn, .beginFromCurrentState], animations: {
                
                self.transform = CGAffineTransform(translationX: 0, y: -180)

            })              { _ in
                self.removeFromSuperview()
            }
            
        }
        
    }
    
    
    @objc func cancelUpload(sender: UIButton) {
        sender.backgroundColor = .red
    }
}
