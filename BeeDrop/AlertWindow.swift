//
//  AlertWindow.swift
//  BeeDrop
//
//  Created by ROBIN ZHOU on 9/28/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import Foundation
import UIKit

class AlertWindow {
    var delKeyWords: [String] =
        ["userName", "requestProduct", "payment", "passcode"]
    init() {}
    
    // Given the delivery info, display delivery info to driver
    func showDriverAccept(info: [String: AnyObject]) {
        let alert = UIAlertView()
        alert.title = "Delivery Request"
        alert.message = formDeliveryInfoMessage(info)
        alert.addButtonWithTitle("Accept")
        alert.show()
    }
    

    
    func formDeliveryInfoMessage(info: [String: AnyObject]) -> String {
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
            if (keyword == "payment") {
                str = "\(info[keyword]! as Double)"
            } else {
                str = (info[keyword]! as? String)!
            }
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
        var info : [String: AnyObject]? = [String: AnyObject]()
        
        let jsonObject: [String: AnyObject] = ["bUser": true, "ID": 21, "name": "Ted", "curLoc": [0.3, 0.0] ]
        let driverObject: [String: AnyObject] = ["bUser": false, "ID": 52, "name": "Mike", "curLoc": [0.3, 0.0] ]
        let driverObject1: [String: AnyObject] = ["bUser": false, "ID": 53, "name": "Philips", "curLoc": [0.30001, 0.0] ]
        
        let jsonObject1: [String: AnyObject] = ["ID": 21, "fromLoc": [0.3, 0.0], "toLoc": [0.3, 0.0], "requestProduct": "shit", "payment": 0.1, "passcode":"1234"]
        let jsonObject2: [String: AnyObject] = ["ID": 21]
        let jsonObject3: [String: AnyObject] = ["userID": 21, "driverID": 53]
        let jsonObject4: [String: AnyObject] = ["driverID": 53]
        
        var handeler = RequestHandler()
        //clear database.
        handeler.sendRequestByURL(jsonObject, tag: "clearAllDataBase")

        handeler.sendRequestByURL(jsonObject, tag: "addPerson")
        handeler.sendRequestByURL(driverObject, tag: "addPerson")
        handeler.sendRequestByURL(driverObject1, tag: "addPerson")
        handeler.sendRequestByURL(jsonObject1, tag: "submitUserDeliveryForm")
        handeler.sendRequestByURL(jsonObject2, tag: "listNearbyDrivers")
        handeler.sendRequestByURL(jsonObject3, tag: "selectDriver")
        info = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")
        println(info)
        return info!
    }
    
}
