//
//  StatusViewAnimation.swift
//  BeeDrop
//
//  Created by ROBIN ZHOU on 9/27/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

enum StatusType {
    case Pending
    case Delivering
}

class StatusView {
    var mstatus: StatusType! = StatusType.Pending
    var mview: UIView
    var mimg: UIImage?
    var mstrStatus: String?
    var mimgView: UIImageView?
    var mlabel: UILabel?
    
    init() {
        self.mstatus = StatusType.Pending
        let mframe = CGRect(x: 50, y: 0, width: 50, height: 50)
        self.mview = UIView(frame: mframe)
        setIconAndLabelAttribute()
        setIconView()
        setLabelView()
    }
    
    func setIconAndLabelAttribute() {
        // Set iconImgName based on statusType.
        var iconImgName: String
        if (mstatus == StatusType.Pending) {
            iconImgName = "waitingIcon.png"
        } else {
            iconImgName = "bee.png"
        }
        self.mimg = UIImage(named: iconImgName)
        
        // Set label text based on statusType.
        if (mstatus == StatusType.Pending) {
            self.mstrStatus = "Waiting to be accepted"
        } else {
            self.mstrStatus = "On Delivery"
        }
    }
    
    func setIconView() {
        // Set up icon image view frame. 
        let imgIconFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.mimgView = UIImageView(frame: imgIconFrame)
        self.mimgView?.image = self.mimg?
        self.mview.addSubview(self.mimgView!)
    }
    
    func setLabelView() {
        // Set up label view frame.
        let labelFrame = CGRectMake(0, 0, 200, 21)
        mlabel = UILabel(frame: labelFrame)
        mlabel?.center = CGPointMake(160, 50)
        mlabel?.textAlignment = NSTextAlignment.Center
        mlabel?.text = mstrStatus
        self.mview.addSubview(self.mlabel!)
    }
    
    func setStatus(status: StatusType) {
        mstatus = status
    }
    
    func appear() {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.mimgView!.frame = CGRectOffset(self.mimgView!.frame, 0, +self.mimgView!.frame.height)
            }, completion: {finished in println("test Animation complete")})
        
    }
    
    func disappear() {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.mimgView!.frame = CGRectOffset(self.mimgView!.frame, 0, -self.mimgView!.frame.height)
            }, completion: {finished in println("test Animation complete")})

    }
    
}