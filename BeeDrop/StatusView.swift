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
    
    let DONE_COLOR = UIColor(red: 3.0/255.0, green: 161.0/255.0, blue: 64.0/255.0, alpha: 0.85)
    let DELIVERING_COLOR = UIColor(red: 74.0/225.0, green: 144.0/255.0, blue: 126.0/255.0, alpha: 0.85)
    let PENDING_COLOR = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 0.85)
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    var mImgView: UIImageView?
    var mImg: UIImage?
    var titleLabel : LTMorphingLabel?
    var detailLabel : UILabel?
    var status : StatusType?
    
    var pointerImageView : UIImageView?
    
    var delegate : MapViewController?
    
    
    var contactButton : UIButton?
    var confirmButton : UIButton?
    var rateButton : UIButton?
    var shareButton : UIButton?
    
    func DEGREES_TO_RADIANS(x : CGFloat) -> CGFloat { return CGFloat(3.14159265 / 180.0) * x }
    
    init(status : StatusType) {
        super.init(frame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 100))
        self.status = status
    }
    
    override func layoutSubviews() {
        mImgView = UIImageView(frame: CGRectMake(22, 22, 44, 44))
        
        titleLabel = LTMorphingLabel(frame: CGRectMake(85, 18, 225, 30))
        titleLabel?.textAlignment = .Left
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        titleLabel?.morphingEffect = .Fall
        
        detailLabel = UILabel(frame: CGRectMake(85, 44, 225, 30))
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
            if let imgView = mImgView {
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveLinear, animations: {
                    imgView.alpha = 0
                }, completion: nil)
            }
            
            mImgView!.image = UIImage(named: "circle")
            if pointerImageView == nil {
                pointerImageView = UIImageView(frame: CGRectMake(11, 10, 12, 17))
            } else {
                pointerImageView?.frame = CGRectMake(11, 10, 12, 17)
                pointerImageView?.removeFromSuperview()
            }
            pointerImageView?.image = UIImage(named: "pointer")
            mImgView!.addSubview(pointerImageView!)
            
            UIView.animateWithDuration(0.25, delay: 0.25, options: .CurveLinear, animations: {
                self.mImgView!.alpha = 1
            }, completion: nil)
        
            
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: {
                self.layer.backgroundColor = self.PENDING_COLOR.CGColor
            }, completion: nil)
        
            titleLabel?.text = "Pending"
            detailLabel?.text = "Waiting for driver to confirm request."
            
            
        case .Delivering:
            
            if let imgView = mImgView {
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveLinear, animations: {
                    imgView.alpha = 0
                }, completion: nil)
            }
            
            mImgView!.image = UIImage(named: "frame")
            if pointerImageView == nil {
                pointerImageView = UIImageView(frame: CGRectMake(18, 14, 27, 11))
            } else {
                pointerImageView?.frame = CGRectMake(22, 14, 27, 11)
                pointerImageView?.removeFromSuperview()
            }
            pointerImageView?.image = nil
            mImgView!.addSubview(pointerImageView!)
            
            contactButton = UIButton(frame: CGRectMake(85, 45, 104, 36))
            contactButton!.alpha = 0
            contactButton!.setBackgroundImage(UIImage(named: "contactdriver"), forState: UIControlState.Normal)
            contactButton!.setBackgroundImage(UIImage(named: "contactdriversel"), forState: UIControlState.Highlighted)
            addSubview(contactButton!)
            
            confirmButton = UIButton(frame: CGRectMake(200, 45, 117, 36))
            confirmButton!.alpha = 0
            confirmButton!.setBackgroundImage(UIImage(named: "confirm"), forState: UIControlState.Normal)
            confirmButton!.setBackgroundImage(UIImage(named: "confirmsel"), forState: UIControlState.Highlighted)
            confirmButton!.addTarget(delegate!, action: Selector("finallyConfirmMF"), forControlEvents: .TouchUpInside)
            addSubview(confirmButton!)
            
            UIView.animateWithDuration(0.25, delay: 0.25, options: .CurveLinear, animations: {
                self.mImgView!.alpha = 1
                self.confirmButton!.alpha = 1
                self.contactButton!.alpha = 1
            }, completion: nil)
            
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: {
                self.layer.backgroundColor = self.DELIVERING_COLOR.CGColor
                self.titleLabel!.frame = CGRectMake(self.titleLabel!.frame.origin.x, self.titleLabel!.frame.origin.y - 8, self.titleLabel!.frame.width, self.titleLabel!.frame.height)
            }, completion: nil)
            
            
            titleLabel?.text = "On its way!"
            detailLabel?.text = ""
        
        case .Done:
            if let imgView = mImgView {
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveLinear, animations: {
                    imgView.alpha = 0
                }, completion: nil)
            }
            
            mImgView!.image = UIImage(named: "circle")
            if pointerImageView == nil {
                pointerImageView = UIImageView(frame: CGRectMake(10, 13, 24, 17))
            } else {
                pointerImageView?.frame = CGRectMake(10, 13, 24, 17)
                pointerImageView?.removeFromSuperview()
            }
            pointerImageView?.image = UIImage(named: "tick")
            mImgView!.addSubview(pointerImageView!)
            
            self.contactButton?.removeFromSuperview()
            self.confirmButton?.removeFromSuperview()
            
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: {
                self.layer.backgroundColor = self.DONE_COLOR.CGColor
                }, completion: nil)
            
            rateButton = UIButton(frame: CGRectMake(85, 45, 86, 36))
            rateButton!.alpha = 0
            rateButton!.setBackgroundImage(UIImage(named: "rate"), forState: UIControlState.Normal)
            rateButton!.setBackgroundImage(UIImage(named: "ratesel"), forState: UIControlState.Highlighted)
            addSubview(rateButton!)
            
            shareButton = UIButton(frame: CGRectMake(181, 45, 103, 36))
            shareButton!.alpha = 0
            shareButton!.setBackgroundImage(UIImage(named: "share"), forState: UIControlState.Normal)
            shareButton!.setBackgroundImage(UIImage(named: "sharesel"), forState: UIControlState.Highlighted)
            addSubview(shareButton!)
            
            UIView.animateWithDuration(0.25, delay: 0.25, options: .CurveLinear, animations: {
                self.mImgView!.alpha = 1
                self.rateButton!.alpha = 1
                self.shareButton!.alpha = 1
            }, completion: nil)
            
            self.titleLabel!.transform = CGAffineTransformMakeTranslation(0, -8)
            
//            titleLabel!.frame = CGRectMake(self.titleLabel!.frame.origin.x, self.titleLabel!.frame.origin.y - 8, self.titleLabel!.frame.width, self.titleLabel!.frame.height)
            
            titleLabel?.text = "Delivered"
            detailLabel?.text = ""
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appear() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeTranslation(0, -90)
            self.updateStatus()
        }, completion: nil)
    }

    func disappear() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
    }
}
