//
//  RequestViewController.swift
//  BeeDrop
//
//  Created by Kevin Chang on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var itemRequest: UITextView!
    @IBOutlet weak var payment: UITextField!
    @IBOutlet weak var passCode: UITextField!
    
    let notCenter = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad() //default was view, but chasnged to scrollview...
        
        // Assign a delegate to trigger return action
        userName.delegate = self
        
        // Notify us when keyboard shows and hides
        notCenter.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        notCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Change the size of scrollview... TODO: nothing happened
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        var scrollView = view as UIScrollView
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight*0.75)
        println("screen W:\(screenWidth) H:\(screenHeight)")
    }
    
    deinit {
        notCenter.removeObserver(self);
    }
    
    /****** KEYBOARD ANIMATION *******/
    // Problem: keyboard coving the textfields/views 
    // Solution: scroll set new offset based on the current textfield position
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo
        let keyboardSize = (info![UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size
        
        // Add a buffer space below the scrollview --> animation needs a delta
        var scrollView = view as UIScrollView
        var contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // -- Detect if the textfield/view are under the keyboard --
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        // Go through every view
        for cView in self.view.subviews {
            // Make sure is Textfield or TextView
            if !cView.isKindOfClass(UITextField) && !cView.isKindOfClass(UITextView){
                continue
            }
            // Check if current view
            if cView.isFirstResponder() {
                if !CGRectContainsPoint(aRect, cView.frame.origin) {
                    var scrollPoint:CGPoint = CGPointMake(0.0, cView.frame.origin.y - keyboardSize.height)
                    scrollView.setContentOffset(scrollPoint, animated: true)
                    break
                }
            }
        }
    }
    
    // Once the keyboard is gone, go back to normal view
    func keyboardWillHide(notification: NSNotification) {
        var scrollView = view as UIScrollView
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    /******* END ANIMATION ********/
   
    // TODO: how to add 'return' to the demical pad?
    
    // After the user presses "Send Request", go back to the map with a new waiting status
    @IBAction func ToViewMap(sender: AnyObject) {
        // TODO: double check if we are indeed going back to the root
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gesture recognizer -- hide keyboard when tap on the screen
    @IBAction func tapScreen()
    {
       view.endEditing(true)
    }
    
    // The action when "return key" is hit in the UserName TextField: Jump to request text view
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == userName {
            self.itemRequest.becomeFirstResponder()
        }
        return true
    }
}
