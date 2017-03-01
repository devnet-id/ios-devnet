//
//  LoadingIndicatorView.swift
//  Devnet
//
//  Created by Zulwiyoza Putra on 2/28/17.
//  Copyright © 2017 Kibar. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label = UILabel()
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    let blurredBackgroundView: UIVisualEffectView
    let dimOverlayBackground = UIView()
    
    init(text: String) {
        self.text = text
        self.blurredBackgroundView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.blurredBackgroundView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    func setup() {
        contentView.addSubview(blurredBackgroundView)
        blurredBackgroundView.contentView.addSubview(activityIndictor)
        blurredBackgroundView.contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2, y: superview.frame.height / 2 - height / 2, width: width, height: height)
            
            blurredBackgroundView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5, y: height / 2 - activityIndicatorSize / 2, width: activityIndicatorSize, height: activityIndicatorSize)
            
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5, y: 0, width: width - activityIndicatorSize - 15, height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hide() {
        self.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
