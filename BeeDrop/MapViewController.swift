//
//  MapViewController.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let appFrame = UIScreen.mainScreen().applicationFrame
    
    /** Map / Location related variables **/
    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D?
    var mapView : MKMapView?
    var searchbarView : UIView?
    var searchDetailViewController : UIViewController?
    var latitude : CLLocationDegrees = 40.44239536653566
    var longtitude : CLLocationDegrees = -79.9457530
    var latDelta : CLLocationDegrees = 0.05
    var longDelta : CLLocationDegrees = 0.05
    var span : MKCoordinateSpan?
    var loc : CLLocationCoordinate2D?
    var region : MKCoordinateRegion?
    var overlay : MKOverlay?
    var directionsRequest : MKDirectionsRequest?
    var route : MKRoute?
    var placemarks = [MKPlacemark]()
    var fromLocation : MKMapItem?
    var toLocation : MKMapItem?
    var fromLocationString : String?
    var toLocationString : String?
    /** **/
    
    var label : UILabel?
    var toolbar : UIToolbar?
    
    /** infoSheet related variables **/
    var checkButton : UIButton?
    var infoSheet : UIView?
    var userName : UITextField?
    var itemRequest : UITextField?
    var payment : UITextField?
    var passCode : UITextField?
    var deliverBy : UITextField?
    var nameLabel : UILabel?
    var itemRequestLabel : UILabel?
    var passCodeLabel : UILabel?
    var paymentLabel : UILabel?
    var deliverByLabel : UILabel?
    var infoSheetLabel : UILabel?
    var tapGestureRecognizer : UITapGestureRecognizer?
    let notCenter = NSNotificationCenter.defaultCenter()
    /** **/
    
    
    /** driveList related variables **/
    var driverListView : UITableView?
    let cellHeight : CGFloat = 44.0
    var driverList : [(name: String, rating: Int, ID: Int)] = [("Searching nearby drivers...", 3, 55)]
    let driverListTableViewCellIdentifier = "driverListTableViewCell"
    var driverListFetchTerminate = false
    /** **/
    
    var statusView : StatusView?
    
    // Hongyi adding handler
    var handeler = RequestHandler()
    
    // Jiaji Adding protoDriver Alert View Popout
    func driverAlertViewPopOut() {
        var alertWindow = AlertWindow()
        dispatch_async(dispatch_queue_create("poll", nil), {
            var info = alertWindow.driverAcceptDataHelper()
            //active listening
            alertWindow.showDriverAccept(info)
            //  alertWindow.showDriverAccept(info)
        })
    }
    
    // MARK: View setups
    
    func setupMapView() {
        
        span = MKCoordinateSpanMake(latDelta, longDelta)
        loc = CLLocationCoordinate2DMake(latitude, longtitude)
        region = MKCoordinateRegionMake(loc!, span!)
        
        mapView = MKMapView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        mapView!.delegate = self
        mapView!.setRegion(region!, animated: true)
        mapView!.showsUserLocation = true
        
        view.addSubview(mapView!)
    }
    
    func setupSearchbarView() {
        searchbarView = UIView(frame: CGRectMake(15, 80, SCREEN_WIDTH - 30, 40))
        
        var imageView = UIButton(frame: CGRectMake(0, 0, 290, 40))
        imageView.setBackgroundImage(UIImage(named: "sbar"), forState: UIControlState.Normal)
        imageView.setBackgroundImage(UIImage(named: "sbar_sel"), forState: UIControlState.Highlighted)
        imageView.addTarget(self, action: Selector("tappedSbar"), forControlEvents: .TouchUpInside)
        
        label = UILabel(frame: CGRectMake(40, 10, 210, 20))
        label!.textColor = UIColor.grayColor()
        label!.font = UIFont.systemFontOfSize(13)
        label!.textAlignment = .Left
        label!.text = "Deliver From / To"
        
        searchbarView?.addSubview(imageView)
        searchbarView?.addSubview(label!)
        
        view.addSubview(searchbarView!)
    }
    
    func setupCoreLocation() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.distanceFilter = kCLDistanceFilterNone
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startMonitoringSignificantLocationChanges()
        locationManager!.startUpdatingLocation()
    }
    
    func setupToolbar() {
        toolbar = UIToolbar(frame: CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44))
        toolbar?.tintColor = UIColor(red: 3.0/255.0, green: 161.0/255.0, blue: 64.0/255.0, alpha: 1)
        toolbar?.items = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "BeeDrop!", style: .Plain, target: self, action: Selector("tappedBeeDrop")),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            ]
    }
    
    func setupNotificationCenter() {
        notCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeNotificationCenter() {
        notCenter.removeObserver(self)
    }
    
    func setupDriverListView() {
        driverListView = UITableView(frame: CGRectMake(-2, SCREEN_HEIGHT, SCREEN_WIDTH + 4, 0))
        
        driverListView?.contentInset = UIEdgeInsetsMake(5, 0, 2, 0)
        driverListView?.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 0.95)
        driverListView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: driverListTableViewCellIdentifier)
        driverListView?.layer.borderColor = UIColor(red: 3.0/255.0, green: 161.0/255.0, blue: 64.0/255.0, alpha: 1).CGColor
        driverListView?.layer.borderWidth = 2.0
        driverListView?.delegate = self
        driverListView?.dataSource = self
    }
    
    func setupStatusView() {
        statusView = StatusView(status: .Pending)
        statusView?.delegate = self
        UIApplication.sharedApplication().keyWindow.addSubview(statusView!)
        
//        var delayInSeconds = 1.0
//        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.statusView!.appear()
//        })
//
//        delayInSeconds = 3.0
//        popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.statusView!.status = .Done
//            self.statusView!.updateStatus()
//        })
//        
//        delayInSeconds = 5.0
//        popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.statusView!.status = .Pending
//            self.statusView!.updateStatus()
//        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loginJson: [String: AnyObject] = [String: AnyObject]()
        
        loginJson["bUser"] = true
        loginJson["ID"] = 21
        loginJson["name"] = "Michael Jordan"
        var lat = 0.0
        var long = 0.0
        if let cl = currentLocation {
            lat = cl.latitude
            long = cl.longitude
        }
        loginJson["curLoc"] = [lat, long]
        
        handeler.sendRequestByURL(loginJson, tag: "addPerson")

        setupCoreLocation()
        setupMapView()
        setupSearchbarView()
        setupToolbar()
        setupStatusView()
        setupDriverListView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Keyboard event handlers
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.infoSheet!.transform = CGAffineTransformMakeTranslation(0, -320 - 245)
        }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.infoSheet!.transform = CGAffineTransformMakeTranslation(0, -320)
        }, completion: nil)
    }
    
    // MARK: Returned from search view
    
    func userEnteredFromToLocation() {
        view.addSubview(toolbar!)
        directionsRequest = MKDirectionsRequest()
        
        if let fl = fromLocation {
            fromLocationString = fl.name
        } else {
            fromLocationString = "Current Location"
            fromLocation = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation!, addressDictionary: nil))
        }
        if let tl = toLocation {
            toLocationString = tl.name
        } else {
            toLocationString = "Current Location"
            toLocation = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation!, addressDictionary: nil))
        }
        label?.text = "Pickup: \(fromLocationString!)"
        label?.font = UIFont.systemFontOfSize(12)
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchbarView!.alpha = 0.85
        })
        
        directionsRequest!.setSource(fromLocation)
        directionsRequest!.setDestination(toLocation)
        var directions = MKDirections(request: directionsRequest!)
        directions.calculateDirectionsWithCompletionHandler({
            (response : MKDirectionsResponse!, error : NSError!) in
            if response != nil && response.routes.count != 0 {
                self.route = response.routes.first as? MKRoute
                if let ol = self.overlay {
                    self.mapView?.removeOverlay(ol)
                }
                self.overlay = self.route?.polyline
                self.mapView?.addOverlay(self.overlay)
            }
        })
        
        mapView?.removeAnnotations(placemarks)
        placemarks.removeAll()
        placemarks.append(fromLocation!.placemark)
        placemarks.append(toLocation!.placemark)
        
        mapView?.addAnnotations(placemarks)
        
        var delayInSeconds = 0.25
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.mapView!.showAnnotations(self.placemarks, animated: true)
        })
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.toolbar!.transform = CGAffineTransformMakeTranslation(0, -44)
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tappedSearchBar" {
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.toolbar!.transform = CGAffineTransformMakeTranslation(0, 44)
            }, completion: nil)
            
            var searchViewController : SearchViewController = segue.destinationViewController as SearchViewController
            searchViewController.delegate = self
            searchViewController.mapRegion = region
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 0, green: 0.51, blue: 1, alpha: 0.6)
        renderer.lineWidth = 6.0
        return renderer
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if userName!.isFirstResponder() {
            itemRequest?.becomeFirstResponder()
        } else if itemRequest!.isFirstResponder() {
            deliverBy?.becomeFirstResponder()
        } else if deliverBy!.isFirstResponder() {
            payment?.becomeFirstResponder()
        } else if payment!.isFirstResponder() {
            passCode?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func resignResponder() {
        userName?.resignFirstResponder()
        itemRequest?.resignFirstResponder()
        payment?.resignFirstResponder()
        passCode?.resignFirstResponder()
        deliverBy?.resignFirstResponder()
    }
    
    func tappedSbar() {
        performSegueWithIdentifier("tappedSearchBar", sender: self)
    }
    
    func tappedBeeDrop() {
        setupNotificationCenter()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        view.addGestureRecognizer(tapGestureRecognizer!)
        
        infoSheet = UIView(frame: CGRectMake(-2, SCREEN_HEIGHT, SCREEN_WIDTH + 4, 500))
        infoSheet?.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 0.95)
        infoSheet?.layer.borderColor = UIColor(red: 3.0/255.0, green: 161.0/255.0, blue: 64.0/255.0, alpha: 1).CGColor
        infoSheet?.layer.borderWidth = 2.0
    
        infoSheetLabel = UILabel(frame: CGRectMake(28, 25, SCREEN_WIDTH - 2 * 20, 25))
        infoSheetLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        infoSheetLabel?.textColor = UIColor.blackColor()
        infoSheetLabel?.text = "We need a bit more information"
        
        nameLabel = UILabel(frame: CGRectMake(14, 74, 80, 20))
        nameLabel?.textAlignment = .Right
        nameLabel?.text = "Your Name"
        nameLabel?.textColor = UIColor.grayColor()
        nameLabel?.font = UIFont.systemFontOfSize(12)
        
        itemRequestLabel = UILabel(frame: CGRectMake(14, 112, 80, 20))
        itemRequestLabel?.textAlignment = .Right
        itemRequestLabel?.text = "Item Request"
        itemRequestLabel?.textColor = UIColor.grayColor()
        itemRequestLabel?.font = UIFont.systemFontOfSize(12)
        
        deliverByLabel = UILabel(frame: CGRectMake(14, 150, 80, 20))
        deliverByLabel?.textAlignment = .Right
        deliverByLabel?.text = "Deliver By"
        deliverByLabel?.textColor = UIColor.grayColor()
        deliverByLabel?.font = UIFont.systemFontOfSize(12)
        
        paymentLabel = UILabel(frame: CGRectMake(14, 188, 80, 20))
        paymentLabel?.textAlignment = .Right
        paymentLabel?.text = "Payment"
        paymentLabel?.textColor = UIColor.grayColor()
        paymentLabel?.font = UIFont.systemFontOfSize(12)
        
        passCodeLabel = UILabel(frame: CGRectMake(14, 226, 80, 20))
        passCodeLabel?.textAlignment = .Right
        passCodeLabel?.text = "Secret Code"
        passCodeLabel?.textColor = UIColor.grayColor()
        passCodeLabel?.font = UIFont.systemFontOfSize(12)
        
        /** -- **/
        
        userName = UITextField(frame: CGRectMake(114, 74, 200, 20))
        userName?.textAlignment = .Left
        userName?.placeholder = "Andrew Carnegie"
        userName?.textColor = UIColor.blackColor()
        userName?.font = UIFont.systemFontOfSize(13)
        userName?.delegate = self
        
        itemRequest = UITextField(frame: CGRectMake(114, 112, 200, 20))
        itemRequest?.textAlignment = .Left
        itemRequest?.placeholder = "A cute doge"
        itemRequest?.textColor = UIColor.blackColor()
        itemRequest?.font = UIFont.systemFontOfSize(13)
        itemRequest?.delegate = self
        
        deliverBy = UITextField(frame: CGRectMake(114, 150, 200, 20))
        deliverBy?.textAlignment = .Left
        deliverBy?.placeholder = "17:30"
        deliverBy?.textColor = UIColor.blackColor()
        deliverBy?.font = UIFont.systemFontOfSize(13)
        deliverBy?.delegate = self
        
        payment = UITextField(frame: CGRectMake(114, 188, 200, 20))
        payment?.textAlignment = .Left
        payment?.placeholder = "5.00"
        payment?.textColor = UIColor.blackColor()
        payment?.font = UIFont.systemFontOfSize(13)
        payment?.keyboardType = UIKeyboardType.DecimalPad
        payment?.delegate = self
        
        passCode = UITextField(frame: CGRectMake(114, 226, 200, 20))
        passCode?.textAlignment = .Left
        passCode?.placeholder = "#meaningoflife"
        passCode?.textColor = UIColor.blackColor()
        passCode?.font = UIFont.systemFontOfSize(13)
        passCode?.delegate = self
        
        
        /** -- **/
        
        infoSheet?.addSubview(infoSheetLabel!)
        infoSheet?.addSubview(nameLabel!)
        infoSheet?.addSubview(itemRequestLabel!)
        infoSheet?.addSubview(deliverByLabel!)
        infoSheet?.addSubview(paymentLabel!)
        infoSheet?.addSubview(passCodeLabel!)
        
        infoSheet?.addSubview(userName!)
        infoSheet?.addSubview(itemRequest!)
        infoSheet?.addSubview(deliverBy!)
        infoSheet?.addSubview(payment!)
        infoSheet?.addSubview(passCode!)
        
        checkButton = UIButton(frame: CGRectMake(SCREEN_WIDTH / 2 - 22, 260, 44, 44))
        checkButton?.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        checkButton?.setBackgroundImage(UIImage(named: "check_sel"), forState: .Highlighted)
        checkButton?.addTarget(self, action: Selector("tappedCheckButton"), forControlEvents: UIControlEvents.TouchUpInside)
        infoSheet?.addSubview(checkButton!)
        
        view.addSubview(infoSheet!)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.searchbarView!.alpha = 0
            self.toolbar!.transform = CGAffineTransformMakeTranslation(0, 44)
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.infoSheet!.transform = CGAffineTransformMakeTranslation(0, -320)
        }, completion: nil)
    }
    
    func tapped() {
        resignResponder()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        currentLocation = newLocation.coordinate
    }
    
    func reloadDriverListView() {
        println("driverList.count \(driverList.count)")
        driverListView!.frame = CGRectMake(
            driverListView!.frame.origin.x,
            SCREEN_HEIGHT - CGFloat(driverList.count) * cellHeight - 10,
            driverListView!.frame.size.width,
            (CGFloat(driverList.count)) * cellHeight + 10)
        driverListView!.reloadData()
    }
    
    func tappedCheckButton() {
        driverListFetchTerminate = true
        
        resignResponder()
        view.removeGestureRecognizer(tapGestureRecognizer!)
        removeNotificationCenter()
        view.addSubview(driverListView!)
        reloadDriverListView()
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.infoSheet!.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)

        
        // Ted Animate
        
//        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            self.driverListView!.transform = CGAffineTransformMakeTranslation(0, -self.driverListView!.frame.size.height + 2)
//        }, completion: nil)
//
//        var delayInSeconds = 1.0
//        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.driverList += [("Fuck", 2)]
//        self.reloadDriverListView()

        
        var submitForm: [String: AnyObject] = [String: AnyObject]()
        
        submitForm["ID"] = 21
        submitForm["fromLoc"] = [fromLocation!.placemark.coordinate.latitude, fromLocation!.placemark.coordinate.longitude]
        submitForm["toLoc"] = [toLocation!.placemark.coordinate.latitude, toLocation!.placemark.coordinate.longitude]
        submitForm["requestProduct"] = itemRequest?.text
        submitForm["payment"] = payment?.text
        submitForm["passcode"] = passCode?.text
        
        handeler.sendRequestByURL(submitForm, tag: "submitUserDeliveryForm")
        
        dispatch_async(dispatch_queue_create("driverListQueue", nil), {
            let listDriverJson: [String: AnyObject] = ["ID": 21]
            
            while self.driverListFetchTerminate {
                usleep(1000000)
//                print("2")
                var retDriverListNil: [String: AnyObject]? = self.handeler.sendRequestByURL(listDriverJson, tag: "listNearbyDrivers")

                if let retDriverList = retDriverListNil {
                    var newDriverList : [(name: String, rating: Int, ID: Int)] = []
                    // Add the drivers to the list
                    for (id: String, data: AnyObject) in retDriverList {
                        var dataDict: [String: AnyObject] = data as [String: AnyObject]
                        var retName: String = dataDict["name"] as AnyObject? as String
                        var retRating: Int = dataDict["rating"] as AnyObject? as Int
                        var intId: Int = id.toInt()!
                        newDriverList += [(name: retName, rating: retRating, ID: intId)]
                    }

                    
                    // Check if the new upated list is the same as the current saved list
                    var bSameList = true
                    if (newDriverList.count == self.driverList.count) {
                        for i in 0..<self.driverList.count {
                            if (self.driverList[i].ID != newDriverList[i].ID) {
                                bSameList = false
                                break
                            }
                        }
                    }
                    else {
                        bSameList = false
                    }
                    if !bSameList {
                        println("Updated the driverlist")
                        
                        self.driverList.removeAll(keepCapacity: false)
                        self.driverList = newDriverList
                        self.reloadDriverListView()
                    }
                }
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(driverListTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        var (text, rating, ID) = driverList[indexPath.row]
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Driver id \(driverList[indexPath.row].ID)")
        var userSelectDriverJson: [String: AnyObject] = [String: AnyObject]()
        userSelectDriverJson["userID"] = 21
        userSelectDriverJson["driverID"] = driverList[indexPath.row].ID
        
        handeler.sendRequestByURL(userSelectDriverJson, tag: "selectDriver")
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.driverListView!.alpha = 0
            }, completion: {
                finished in
                self.driverListView!.removeFromSuperview()
                self.statusView!.appear()
                
                dispatch_async(dispatch_queue_create("waitConfirmQueue", nil), {
                    
                    var returnedJson: [String: AnyObject] = [String: AnyObject]()
                    let userConfirmJson: [String: AnyObject] = ["userID": 21]
                    
                    var retStatus = -1
                    
                    while (retStatus == -1) {
                        usleep(500000)
                        var retStatusJsonNil: [String: AnyObject]? = self.handeler.sendRequestByURL(userConfirmJson, tag: "pollDriverAck")
                        
                        if let retStatusJson = retStatusJsonNil {
                            retStatus = retStatusJson["status"] as AnyObject? as Int
                            
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.statusView!.status = .Delivering
                        self.statusView!.updateStatus()
                    })
                })

                
                
//              self.statusView!.status = .Delivering
//              self.statusView!.updateStatus()
        })
    }
}
