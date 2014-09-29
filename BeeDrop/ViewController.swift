//
//  ViewController.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, FBLoginViewDelegate {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    var currentChoice = 0
    let choices = ["Get stuff delivered", "Help deliver stuff"]
    
    var backgroundImageBlurView : UIView?
    var backgroundImageView : UIImageView?
    var hero : LTMorphingLabel?
    var tagline : UITextView?
    var loadingLabel : LTMorphingLabel?
    var shimmeringChoice : FBShimmeringView?
    var arrowImageView : UIImageView?
    var prevArrowImageView : UIImageView?

    var fbLoginView : FBLoginView?
    
    //Hongyi adding handler
    var handeler = RequestHandler()
    
    func setupBackgroundImageView() {
        
        backgroundImageView = UIImageView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        backgroundImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView?.image = UIImage(named: "1.jpg")
        
        backgroundImageBlurView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        insertBlurView(backgroundImageBlurView!, UIBlurEffectStyle.Dark)
        
        view.addSubview(backgroundImageView!)
        view.addSubview(backgroundImageBlurView!)
        
        var transformScale = CGAffineTransformMakeScale(1, 1)
        var transformTranslation = CGAffineTransformMakeTranslation(0, 0)
        backgroundImageView?.transform = CGAffineTransformConcat(transformScale, transformTranslation)
        UIView.animateWithDuration(15, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            var transformScale = CGAffineTransformMakeScale(1.35, 1.35)
            var transformTranslation = CGAffineTransformMakeTranslation(-250, -100)
            self.backgroundImageView!.transform = CGAffineTransformConcat(transformScale, transformTranslation)
        }, completion: nil)
    }
    
    func setupHero() {
        hero = LTMorphingLabel(frame: CGRectMake(0, 105, SCREEN_WIDTH, 75))
        hero!.morphingEffect = .Anvil
        hero!.textColor = UIColor.whiteColor()
        hero!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 52.0)
        hero!.textAlignment = .Center
        view.addSubview(hero!)
        self.hero!.text = "BeeDrop"
    }
    
    func setupTagline() {
        let offset = CGFloat(SCREEN_WIDTH / 8.0)
        tagline = UITextView(frame: CGRectMake(offset, 200, (SCREEN_WIDTH - offset * 2), 100))
        tagline!.userInteractionEnabled = false
        tagline!.backgroundColor = UIColor.clearColor()
        tagline!.textColor = UIColor.whiteColor()
        tagline!.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        tagline!.textAlignment = .Center
        view.addSubview(tagline!)
        tagline!.text = "Deliever and receive your items like never before."
        tagline!.alpha = 0
        tagline!.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.5, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.tagline!.alpha = 1
            self.tagline!.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
    }
    
    func setupChoice() {
        let offset = CGFloat(SCREEN_WIDTH / 8.0)
        shimmeringChoice = FBShimmeringView(frame: CGRectMake(offset, 305, (SCREEN_WIDTH - offset * 2), 50))
        view.addSubview(shimmeringChoice!)
        
        loadingLabel = LTMorphingLabel(frame: shimmeringChoice!.bounds)
        loadingLabel!.textAlignment = .Center
        loadingLabel!.textColor = UIColor(white: 0.8, alpha: 1)
        loadingLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        loadingLabel!.text = choices[currentChoice]
        shimmeringChoice!.contentView = loadingLabel
        shimmeringChoice!.shimmering = true
        shimmeringChoice!.shimmeringDirection = FBShimmerDirection.Left
        loadingLabel!.alpha = 0
        UIView.animateWithDuration(0.5, delay: 2, options: .CurveEaseInOut, animations: {
            self.loadingLabel!.alpha = 1
        }, completion: nil)
        
        var swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: Selector("choiceSwiped"))
        swipeRecognizerRight.direction = .Right
        
        var swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: Selector("choiceSwiped"))
        swipeRecognizerLeft.direction = .Left
        view.addGestureRecognizer(swipeRecognizerRight)
        view.addGestureRecognizer(swipeRecognizerLeft)
    }
    
    func setupArrow() {
        arrowImageView = UIImageView(frame: CGRectMake(SCREEN_WIDTH - 40, 322, 12, 20))
        arrowImageView!.image = UIImage(named: "next")
        view.addSubview(arrowImageView!)
        arrowImageView!.alpha = 0
        UIView.animateWithDuration(0.5, delay: 2, options: .CurveEaseInOut, animations: {
            self.arrowImageView!.alpha = 0
        }, completion: nil)
        
        prevArrowImageView = UIImageView(frame: CGRectMake(28, 322, 12, 20))
        prevArrowImageView!.image = UIImage(named: "prev")
        view.addSubview(prevArrowImageView!)
        prevArrowImageView!.alpha = 0
        UIView.animateWithDuration(0.5, delay: 2, options: .CurveEaseInOut, animations: {
            self.prevArrowImageView!.alpha = 0.75
        }, completion: nil)
    }
    
    func setupFBLoginView() {
        FBSettings.setDefaultAppID("304421096410772")
        fbLoginView = FBLoginView()
        fbLoginView!.delegate = self
        fbLoginView!.readPermissions = ["public_profile"]
        fbLoginView!.center = CGPointMake(SCREEN_WIDTH / 2, 400)
        fbLoginView!.alpha = 0
        view.addSubview(fbLoginView!)
        
        UIView.animateWithDuration(0.5, delay: 2, options: .CurveEaseInOut, animations: {
            self.fbLoginView!.alpha = 1
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupBackgroundImageView()
        var delayInSeconds = 0.5
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.setupHero()
            self.setupTagline()
            self.setupChoice()
            self.setupArrow()
            self.setupFBLoginView()
        });
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func choiceSwiped() {
        currentChoice = abs(1 - currentChoice)
        if currentChoice == 0 {
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                self.arrowImageView!.alpha = 0
                self.prevArrowImageView!.alpha = 0.75
                self.loadingLabel!.text = self.choices[self.currentChoice]
                self.shimmeringChoice!.shimmeringDirection = FBShimmerDirection.Left
            }, completion: nil)
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
                self.arrowImageView!.alpha = 0.75
                self.prevArrowImageView!.alpha = 0
                self.loadingLabel!.text = self.choices[self.currentChoice]
                self.shimmeringChoice!.shimmeringDirection = FBShimmerDirection.Right
            }, completion: nil)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("Logged in!")
        if currentChoice == 0 {
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "IS_DRIVER")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "IS_DRIVER")
        }
        
        FBRequestConnection.startForMeWithCompletionHandler {
            (connection : FBRequestConnection!, fbUserData, error) -> Void in
            var firstName = fbUserData.first_name
            var lastName = fbUserData.last_name
//            var userID = fbUserData.ID
            NSUserDefaults.standardUserDefaults().setObject(firstName + " " + lastName, forKey: "USER_NAME")
//            NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "USER_ID")
        }
        
        var delayInSeconds = 0.5
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("facebookLoggedIn", sender: self)
        });
    }
}

