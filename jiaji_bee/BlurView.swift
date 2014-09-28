//
//  BlurView.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

func insertBlurView (view: UIView, style: UIBlurEffectStyle) {
    view.backgroundColor = UIColor.clearColor()
    
    // Blur Effect
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.alpha = 0.6
    blurEffectView.frame = view.bounds
    
    // Vibrancy Effect
//    var vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
//    var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//    vibrancyEffectView.frame = view.bounds
    
    blurEffectView.frame = view.bounds
    view.insertSubview(blurEffectView, atIndex: 0)
//    blurEffectView.contentView.addSubview(vibrancyEffectView)
}