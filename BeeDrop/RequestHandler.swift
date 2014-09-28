//
//  RequestHandler.swift
//  BeeDrop
//
//  Created by Hongyi Xin on 9/27/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import Foundation

//let HOST_URL = "128.237.187.154:5000"
let HOST_URL = "calm-sands-2322.herokuapp.com  "

class RequestHandler : NSObject, NSURLConnectionDataDelegate {
    
    func JSONStringify(jsonObj: AnyObject) -> String {
        var e: NSError?
        let jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(
            jsonObj,
            options: NSJSONWritingOptions(0),
            error: &e)
        if e != nil {
            return ""
        } else {
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding)
        }
    }
    
    func JSONParseArray(jsonString: String) -> AnyObject? {
        var e: NSError?
        var data: NSData!=jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        var jsonObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e)
        if e != nil {
            return nil
        } else {
            return jsonObj
        }
    }
    
    func sendRequestByURL(dict: Dictionary<String, AnyObject>, tag: String) -> [String: AnyObject]? {
        
        let jsonString = JSONStringify(dict)
        
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: "http://" + HOST_URL + "/" + tag), cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var error: NSError?
        
        // create some JSON data and configure the request
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // send the request
        var retData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
        
        // look at the response
        if let httpResponse = response as? NSHTTPURLResponse {
            println("HTTP response: \(httpResponse.statusCode)")
            var retString: String = NSString(data:retData, encoding:NSUTF8StringEncoding)
            println(retString)
            return JSONParseArray(retString) as? [String: AnyObject]
        } else {
            println("No HTTP response")
            return nil
        }
    }
}