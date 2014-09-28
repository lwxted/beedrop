//
//  StatusView.swift
//  BeeDrop
//
//  Created by Ted Li on 9/28/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

enum StatusType {
    case Pending
    case Delivering
    case Done
}

class StatusView: UIView {
    
    let DONE_COLOR = UIColor(red: 3.0/255.0, green: 161.0/255.0, blue: 64.0/255.0, alpha: 0.96)
    let DELIVERING_COLOR = UIColor(red: 74.0/225.0, green: 144.0/255.0, blue: 126.0/255.0, alpha: 0.96)
    let PENDING_COLOR = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 0.96)
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    var mImgView: UIImageView?
    var mImg: UIImage?
    var titleLabel : LTMorphingLabel?
    var detailLabel : UILabel?
    var status : StatusType?
    
    var delegate : MapViewController?
    
    init(status : StatusType) {
        super.init(frame: CGRectMake(0, -100, SCREEN_WIDTH, 100))
        self.status = status
    }
    
    override func layoutSubviews() {
        mImgView = UIImageView(frame: CGRectMake(20, 33, 44, 44))
        
        titleLabel = LTMorphingLabel(frame: CGRectMake(90, 28, 225, 30))
        titleLabel?.textAlignment = .Left
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        titleLabel?.morphingEffect = .Fall
        
        detailLabel = UILabel(frame: CGRectMake(90, 53, 225, 30))
        detailLabel?.textAlignment = .Left
        detailLabel?.textColor = UIColor.whiteColor()
        detailLabel?.font = UIFont(name: "HelveticaNeue", size: 13)
        
        updateStatus()
        
        addSubview(mImgView!)
        addSubview(titleLabel!)
        addSubview(detailLabel!)
    }
    
    func updateStatus() {
        switch status! {
        case .Pending:
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                self.layer.backgroundColor = self.PENDING_COLOR.CGColor
            }, completion: nil)
            mImgView?.image = UIImage(named: "circle")
            titleLabel?.text = "Pending"
            detailLabel?.text = "Waiting for driver to accept request"
        case .Delivering:
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                self.layer.backgroundColor = self.DELIVERING_COLOR.CGColor
            }, completion: nil)
            mImgView?.image = UIImage(named: "frame")
            titleLabel?.text = "On its way!"
            detailLabel?.text = "Your item is on its way"
        case .Done:
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                self.layer.backgroundColor = self.DONE_COLOR.CGColor
            }, completion: nil)
            mImgView?.image = UIImage(named: "circle")
            titleLabel?.text = "Delivered"
            detailLabel?.text = "Your item has been delivered"
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appear() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeTranslation(0, 100)
        }, completion: nil)
    }

    func disappear() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
    }
}
