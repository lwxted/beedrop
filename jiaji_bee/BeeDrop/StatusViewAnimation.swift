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
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    init() {
        //self.mstatus = StatusType.Pending
        let mframeWidth = SCREEN_WIDTH
        let mframeHeight = SCREEN_HEIGHT * 0.25
        let mframe = CGRect(x: 0, y: 0, width: mframeWidth, height: mframeHeight)
        self.mview = UIView(frame: mframe)
        setStatus(StatusType.Pending)
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
        let imgIconFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
        self.mimgView = UIImageView(frame: imgIconFrame)
        self.mimgView?.image = self.mimg?
        self.mview.addSubview(self.mimgView!)
    }
    
    func setLabelView() {
        // Set up label view frame.
        let labelFrame = CGRectMake(150, 75, 200, 21)
        mlabel = UILabel(frame: labelFrame)
        mlabel?.center = CGPointMake(200, 80)
        mlabel?.textAlignment = NSTextAlignment.Center
        mlabel?.text = mstrStatus
        mlabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        self.mview.addSubview(self.mlabel!)
    }
    
    func setStatus(status: StatusType) {
        mstatus = status
        let mframeWidth = SCREEN_WIDTH
        let mframeHeight = SCREEN_HEIGHT * 0.25
        let mframe = CGRect(x: 0, y: 0, width: mframeWidth, height: mframeHeight)
        self.mview = UIView(frame: mframe)
        setIconAndLabelAttribute()
        setIconView()
        setLabelView()
        
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