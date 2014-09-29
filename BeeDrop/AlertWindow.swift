//
//  AlertWindow.swift
//  BeeDrop
//
//  Created by ROBIN ZHOU on 9/28/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import Foundation
import UIKit

class AlertWindow : NSObject, UIAlertViewDelegate {
    var delKeyWords: [String] =
        ["userName", "requestProduct", "payment", "passcode"]
    var mDriverId: Int
    var mMatchedUserId: Int
    
    override init() {
        mDriverId = -1
        mMatchedUserId = -1
        super.init()
    }
    
    // Given the delivery info, display delivery info to driver
    func showDriverAccept(info: [String: AnyObject]) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertView()
            alert.title = "Delivery Request"
            alert.message = self.formDeliveryInfoMessage(info)
            alert.addButtonWithTitle("Accept")
            alert.delegate = self
            alert.show()
            sleep(2)
            let jsonObjectDriverConfirm: [String: AnyObject] = ["userID": self.mMatchedUserId]
            // Send request to server.
            var handeler = RequestHandler()
            handeler.sendRequestByURL(jsonObjectDriverConfirm, tag: "driverAcceptRequest")
            println("sent out confirm to \(self.mMatchedUserId)")

        })
    }

    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("button clicked")
        switch buttonIndex {
        case 0:
            // Form jsonObject Containing the UserId in delivery order.
            let jsonObjectDriverConfirm: [String: AnyObject] = ["userID": mMatchedUserId]
            // Send request to server.
            var handeler = RequestHandler()
            handeler.sendRequestByURL(jsonObjectDriverConfirm, tag: "driverAcceptRequest")
            println("sent out confirm to \(mMatchedUserId)")
            break
        default:
            println("clicked Nothing")
        }
    }
    
    func setDriverId(driverId: Int) {
        mDriverId = driverId
    }
    
    func formDeliveryInfoMessage(info: [String: AnyObject]) -> String {
        // Extract delivery user Id.
        mMatchedUserId = info["userID"]! as Int
        var mAttr: [String] = []
        for keyword in delKeyWords {
            //var str: String
            println(keyword)
            if let str = (info[keyword]! as? String)? {
                println(str)
                mAttr.append(str)
            } else {
                mAttr.append(" ")
            }
        }
        var message = mAttr[0] + " wants you to deliver "  + mAttr[1] +  "!\n"
        message += "Payment amount is " + mAttr[2] + "\n"
        message += "Password is " + mAttr[3]
        return message
    }
    
    // Given the delivery info dict, return double array as [src_x, src_y, dst_x, dst_y].
    func extractDeliverySrcDst(info: [String: AnyObject]) -> [Double] {
        var ret: [Double] = []
        let cord_x = info["fromLoc"]! as [Double]
        let cord_y = info["toLoc"]! as [Double]
        ret = [cord_x[0], cord_x[1], cord_y[0], cord_y[1]]
        println(ret)
        return ret
    }
    
    func driverAcceptDataHelper() -> [String: AnyObject] {
        let driverObject1: [String: AnyObject] = ["bUser": false, "ID": 53, "name": "Philips", "curLoc": [0.30001, 0.0] ]
        let jsonObject4: [String: AnyObject] = ["driverID": 53]
        
        var handeler = RequestHandler()
        
        handeler.sendRequestByURL(driverObject1, tag: "addPerson")
        var info: [String: AnyObject] = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")!
        
        // Keep on polling user request
        while ( (info["status"] as AnyObject? as? Int) == -1) {
            info = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")!
            sleep(1)
        }
        return info
    }
    
}
