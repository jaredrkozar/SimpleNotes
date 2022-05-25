//
//  AlertController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/22/22.
//

import UIKit

class ToastNotification: UIView, UIGestureRecognizerDelegate {
  
    private var imageView: UIImageView {
        let image = UIImageView()
        image.tintColor = UIColor.white
        image.frame = CGRect(x: 5, y: 10, width: 50, height: 50)
        image.image = UIImage(systemName: "pin")
        image.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
        return image
    }
    
    
    func showToast(backgroundColor: UIColor, image: UIImage, titleText: String, subtitleText: String?, progress: Double?) {
        
        let window =  UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        self.frame = CGRect(x: 30, y: -70, width: Constants.screenWidth - 60, height: 70)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = Constants.cornerRadius
        self.alpha = 1.0
        
        imageView.image = image
        self.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        titleLabel.frame = CGRect(x: 65, y: 10, width: UIScreen.main.nativeBounds.width - 45, height: 20)
        titleLabel.text = titleText
        self.addSubview(titleLabel)
        
        if progress == nil {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
            subtitleLabel.frame = CGRect(x: 65, y: 35, width: 45, height: 20)
            subtitleLabel.text = subtitleText
            self.addSubview(subtitleLabel)
        } else {
            let progressView = UIProgressView()
            progressView.progress = 0.35
            progressView.frame = CGRect(x: 65, y: 45, width: self.bounds.maxX - 65 - 15, height: 30)
            progressView.progressTintColor = .white
            progressView.trackTintColor = backgroundColor.darker(by: 40.0)
            self.addSubview(progressView)
        }
        
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
}
