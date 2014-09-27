//
//  ViewController.swift
//  SwiftTable
//
//  Created by Tim on 20/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let cellIdentifier = "myCell"
    var tableName = [String]()
    var tableRate = [UIImage]()
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the UITableViewCell class with the tableView
        
        
//        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        // Setup table data
        // Setup table data
        self.tableName.append("Hongyi")
        self.tableName.append("Kevin")
        self.tableName.append("Jiaji")
        self.tableName.append("Ted")
        
        self.tableRate.append(UIImage(named: "1star") )
        self.tableRate.append(UIImage(named: "2star") )
        self.tableRate.append(UIImage(named: "3star") )
        self.tableRate.append(UIImage(named: "4star") )
        self.tableRate.append(UIImage(named: "5star") )
        
//        self.tableView!.frame = CGRectMake(0, SCREEN_HEIGHT-500,SCREEN_WIDTH, CGFloat(tableName.count * 44))
        
        self.tableView!.frame.size.height = CGFloat(tableName.count * 44)

        self.tableView!.frame.origin.y = SCREEN_HEIGHT - CGFloat(self.tableView!.frame.height)
        
        movePannel(&(tableView!.frame), track: -self.tableView!.frame.height)
        
//        self.tableView!.frame.origin.y = SCREEN_HEIGHT
        
//        movePannel(&(tableView!.frame), track: self.tableView!.frame.height)

    }
    
    override func awakeFromNib() {
        let tb = self.tableView
        
        super.awakeFromNib()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell
        
//        cell.imageView?.image = self.tableRate[indexPath.row]
//        var img : UIImageView? = cell.viewWithTag(100) as? UIImageView
        var img : UIImageView? = UIImageView.viewWithTag(cell)(100) as? UIImageView
        img!.image = self.tableRate[indexPath.row]
        
        var name : UITextView? = UITextView.viewWithTag(cell)(101) as? UITextView
        name!.text = self.tableName[indexPath.row]
        
        return cell
    }
    
    func movePannel(inout pannel: CGRect, track: CGFloat) {
        
        UIView.animateWithDuration(0.5, delay:0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.tableView!.frame = CGRectOffset(pannel, 0, track)
//            self.tableView!.frame = CGRectOffset(self.tableView!.frame, 0, -self.tableView!.frame.height)
            }, completion: {finished in println("test Animation complete")})
        
    }
    
    
    // UITableViewDelegate methods
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        self.tableView!.frame.origin.y = SCREEN_HEIGHT
        
        movePannel(&(tableView!.frame), track: self.tableView!.frame.height)
        
//        let alert = UIAlertController(title: "Item selected", message: "You selected item \(indexPath.row)", preferredStyle: UIAlertControllerStyle.Alert)
//    
//        alert.addAction(UIAlertAction(title: "OK",
//                                      style: UIAlertActionStyle.Default,
//                                    handler: {
//                                        (alert: UIAlertAction!) in println("An alert of type \(alert.style.hashValue) was tapped!")
//                                        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
//                                    }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

