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
            
            let jsonObjectDriverConfirm: [String: AnyObject] = ["userID": self.mMatchedUserId]
            // Send request to server.
            var handeler = RequestHandler()
            handeler.sendRequestByURL(jsonObjectDriverConfirm, tag: "driverAcceptRequest")
            sleep(5.0)
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
            var str: String
            /*
            if (keyword == "fromLoc" || keyword == "toLoc") {
                let coords = info[keyword]! as [Double]
                str = "( + \(coords[0]) + , + \(coords[1]) + )"
            } else {
                str = (info[keyword]! as? String)!
            }
            */
            println(keyword)
            /*
            if (keyword == "payment") {
                var money: Float = info[keyword] as AnyObject? as Float
                println ("money: \(money)")
                str = "\(money)"
            } else {
                str = (info[keyword]! as? String)!
            }
            */
            str = (info[keyword]! as? String)!
            println(str)
            mAttr.append(str)
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
      //  var info : [String: AnyObject] = [String: AnyObject]()
        
        let jsonObject: [String: AnyObject] = ["bUser": true, "ID": 21, "name": "Ted", "curLoc": [0.3, 0.0] ]
        let driverObject: [String: AnyObject] = ["bUser": false, "ID": 52, "name": "Mike", "curLoc": [0.3, 0.0] ]
        let driverObject1: [String: AnyObject] = ["bUser": false, "ID": 53, "name": "Philips", "curLoc": [0.30001, 0.0] ]
        
        let jsonObject1: [String: AnyObject] = ["ID": 21, "fromLoc": [0.3, 0.0], "toLoc": [0.3, 0.0], "requestProduct": "shit", "payment": 0.1, "passcode":"1234"]
        let jsonObject2: [String: AnyObject] = ["ID": 21]
        let jsonObject3: [String: AnyObject] = ["userID": 21, "driverID": 53]
        let jsonObject4: [String: AnyObject] = ["driverID": 53]
        
        var handeler = RequestHandler()
        //clear database.
       // handeler.sendRequestByURL(jsonObject, tag: "clearAllDataBase")
        /*
        handeler.sendRequestByURL(jsonObject, tag: "addPerson")
        handeler.sendRequestByURL(driverObject, tag: "addPerson")
        handeler.sendRequestByURL(driverObject1, tag: "addPerson")
        handeler.sendRequestByURL(jsonObject1, tag: "submitUserDeliveryForm")
        handeler.sendRequestByURL(jsonObject2, tag: "listNearbyDrivers")
        handeler.sendRequestByURL(jsonObject3, tag: "selectDriver")
        info = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")
        println(info)
        */
        handeler.sendRequestByURL(driverObject1, tag: "addPerson")
        var info: [String: AnyObject] = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")!
        while ( (info["status"] as AnyObject? as? Int) == -1) {
            info = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")!
            sleep(2)
        }
        return info
    }
    
}
