//
//  AlertController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/22/22.
//

import UIKit

class ToastNotification: UIView {
<<<<<<< HEAD
  
=======

>>>>>>> ios-16
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor.white
        image.frame = CGRect(x: 5, y: 10, width: 50, height: 50)
        image.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .large)
        return image
    }()
    
<<<<<<< HEAD
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
=======
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
>>>>>>> ios-16
    
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
<<<<<<< HEAD

=======
        
>>>>>>> ios-16
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = Constants.cornerRadius
        self.alpha = 1.0
        
        imageView.image = image
        self.addSubview(imageView)
        
<<<<<<< HEAD
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

=======
        titleLabel.text = title
        self.addSubview(titleLabel)
    
>>>>>>> ios-16
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
