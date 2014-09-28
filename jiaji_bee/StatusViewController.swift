//
//  StatusViewController.swift
//  BeeDrop
//
//  Created by ROBIN ZHOU on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

enum StatusType {
    case Pending
    case Delivering
}

class StatusViewController: UIViewController {

    @IBOutlet weak var statusIcon: UIImageView!
    
    var mstatus: StatusType! = StatusType.Pending
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set status to be pending initially.
        setStatus(StatusType.Delivering)
        showStatusLabel()
        showStatusIcon()
        
        testAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testAnimation() {
        var testFrame = CGRect(x: 50, y: 0, width: 50, height: 50)
        var testView = UIView(frame: testFrame)
        
        let img = UIImage(named: "waitingIcon.png")
        let imgView = UIImageView(frame: testFrame)
        imgView.image = img
        testView.addSubview(imgView)
        
        self.view.addSubview(testView)

        // self.view.transform = CGAffineTransform(a: 1, b:0 , c:0, d:1, tx:0, ty:-200)
        testView.transform = CGAffineTransformMakeTranslation(0, -100)
        
        UIView.animateWithDuration(0.5, delay: 1.0, options: .CurveEaseOut, animations: {
            testView.transform = CGAffineTransformMakeTranslation(0, 100)
            //    self.view.transform = CGAffineTransform(a:1, b:0 , c:0, d:1, tx:0, ty:-100)
            }, completion: { finished in
                println("test Animation!")
        })
    /*
        // self.view.transform = CGAffineTransform(a: 1, b:0 , c:0, d:1, tx:0, ty:-200)
        self.view.transform = CGAffineTransformMakeTranslation(0, -100)
       
        UIView.animateWithDuration(0.5, delay: 1.0, options: .CurveEaseOut, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0, -50)
        //    self.view.transform = CGAffineTransform(a:1, b:0 , c:0, d:1, tx:0, ty:-100)
            }, completion: { finished in
                println("test Animation!")
        })
        //self.view.transform = CGAffineTransform(a:1, b:0 , c:0, d:1, tx:0, ty:-100)
        */
    }
    func setStatus(status: StatusType) {
        mstatus = status
    }
    
    func showStatusIcon() {
        var iconImgName: String
        if (mstatus == StatusType.Pending) {
            iconImgName = "waitingIcon.png"
        } else {
            iconImgName = "bee.png"
        }
        let img = UIImage(named: iconImgName)
        statusIcon.image = img
        self.view.addSubview(statusIcon)
    }
    
    func showStatusLabel() {
        // Show status label.
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(160, 50)
        label.textAlignment = NSTextAlignment.Center
        var strStatus: String
        if (mstatus == StatusType.Pending) {
            strStatus = "Waiting to be accepted"
        } else {
            strStatus = "On Delivery"
        }
        label.text = strStatus
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        self.view.addSubview(label)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
