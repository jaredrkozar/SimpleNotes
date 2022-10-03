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
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        titleLabel.frame = CGRect(x: 65, y: 10, width: Constants.screenWidth - 60 - 100, height: 20)
        return titleLabel
    }()

    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        subtitleLabel.frame = CGRect(x: 65, y: 35, width: Constants.screenWidth - 60 - 100, height: 20)
        return subtitleLabel
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        print(UIScreen.main.nativeBounds.width)
        progressView.frame = CGRect(x: 65, y: 45, width: Constants.screenWidth - 60 - 100, height: 30)
        progressView.progressTintColor = .white
        progressView.trackTintColor = .black.withAlphaComponent(0.4)
        return progressView
    }()
    
    private var cancelButton: UIButton {
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: self.bounds.maxX - 80, y: 10, width: 70, height: 50)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.layer.cornerRadius = Constants.cornerRadius
        return cancelButton
    }
    
    private var animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
    
    init(backgroundColor: UIColor, image: UIImage, titleText: String, subtitleText: String?) {
        super.init(frame: CGRect(x: 30, y: -70, width: Constants.screenWidth - 60, height: 70))
        subtitleLabel.text = subtitleText
        self.addSubview(subtitleLabel)
        
        toastCreator(title: titleText, image: image, backgroundColor: backgroundColor)
    }
    
    func updateProgress(progress: Float) {
        progressView.progress = progress
        
        if progress >= 0.99 {
            animator.addAnimations {
                self.transform = CGAffineTransform(translationX: 0, y:( self.frame.maxY * -1))
            }
         
            animator.addCompletion({_ in
                
                self.removeFromSuperview()
            })
            animator.startAnimation()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, image: UIImage, titleText: String, progress: Double?) {
        super.init(frame: CGRect(x: 30, y: -70, width: Constants.screenWidth - 60, height: 70))
        progressView.progress = Float(progress!)
        self.addSubview(progressView)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = backgroundColor.darker(by: 40.0)
        self.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(cancelUpload(_:)), for: .touchUpInside)
        
        toastCreator(title: titleText, image: image, backgroundColor: backgroundColor)
    }
    
    private func toastCreator(title: String, image: UIImage, backgroundColor: UIColor) {
        let window =  UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = Constants.cornerRadius
        self.alpha = 1.0
        
        imageView.image = image
        self.addSubview(imageView)
        
        titleLabel.text = title
        self.addSubview(titleLabel)
    
        window?.addSubview(self)
        
        animator.addAnimations {
            self.transform = CGAffineTransform(translationX: 0, y: 180)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.addGestureRecognizer(panGesture)

        animator.startAnimation()
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            if(sender.velocity(in: self).y < 0)
           {
                self.center = CGPoint(x: self.center.x, y: self.center.y + sender.translation(in: self).y)
           } else {
               self.center = CGPoint(x: self.center.x, y: (self.center.y + sender.translation(in: self).y) * 0.9)
           }
            
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            if self.frame.maxY < 0 {
                self.removeFromSuperview()
            } else {
                animator.addAnimations {
                    self.transform = CGAffineTransform(translationX: 0, y:( self.frame.maxY * -1))
                }
             
                animator.addCompletion({_ in
                    
                    self.removeFromSuperview()
                })
                animator.startAnimation()
            }
        default:
            return
        }
    }
    
    @objc func cancelUpload(_ sender: UIButton) {
        animator.addAnimations {
            self.transform = CGAffineTransform(translationX: 0, y: -180)
        }
     
        animator.addCompletion({_ in
            
            self.removeFromSuperview()
        })
        
        animator.startAnimation()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let velocity = gestureRecognizer.velocity(in: self)
        return abs(velocity.x) < abs(velocity.y)
    }
}
