//
//  SearchViewController.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    var delegate : MapViewController?
    
    var textFieldFrom : UITextField?
    var textFieldTo : UITextField?
    var searchImageView: UIImageView?
    var searchBarView : UIView?
    var tableView : UITableView?
    var fromLocationString : String?
    var toLocationString : String?
    
    var fromLocation : MKMapItem?
    var toLocation : MKMapItem?
    
    var searchLocation : String?
    var mapRegion : MKCoordinateRegion?
    var fromLocationCoordinate : CLLocationCoordinate2D?
    var toLocationCoordinate : CLLocationCoordinate2D?
    var searchResults = [MKMapItem]()
    let cellIdentifier = "searchViewTableCellIdentifier"

    func setupSearchView() {
        
        searchBarView = UIView(frame: CGRectMake(0, 0, 320, 101))
        searchImageView = UIImageView(frame: CGRectMake(0, 0, 320, 101))
        searchImageView?.image = UIImage(named: "dbar")
        textFieldFrom = UITextField(frame: CGRectMake(45, 31, 450, 20))
        textFieldTo = UITextField(frame: CGRectMake(45, 67, 450, 20))
        
        textFieldFrom?.placeholder = "From"
        textFieldTo?.placeholder = "To"
        
        textFieldFrom?.delegate = self
        textFieldTo?.delegate = self
        
        textFieldFrom?.font = UIFont.systemFontOfSize(15)
        textFieldTo?.font = UIFont.systemFontOfSize(15)
        
        textFieldFrom?.returnKeyType = UIReturnKeyType.Search
        textFieldTo?.returnKeyType = UIReturnKeyType.Search
        
        searchBarView?.addSubview(searchImageView!)
        searchBarView?.addSubview(textFieldFrom!)
        searchBarView?.addSubview(textFieldTo!)
        
        searchBarView?.layer.shadowColor = UIColor.grayColor().CGColor
        searchBarView?.layer.shadowOffset = CGSizeMake(0, 2)
        searchBarView?.layer.shadowOpacity = 0.75
        searchBarView?.layer.shadowRadius = 4
        
        view.addSubview(searchBarView!)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRectMake(0, 101, SCREEN_WIDTH, SCREEN_HEIGHT - 101), style: UITableViewStyle.Plain)
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        setupTableView()
        setupSearchView()
        textFieldFrom?.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchLocation = textField.text
        textField.resignFirstResponder()
        
        var localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchLocation!
        localSearchRequest.region = mapRegion!
        var localSearch = MKLocalSearch(request: localSearchRequest)
        searchResults.removeAll()
        localSearch.startWithCompletionHandler({
            (searchResponse : MKLocalSearchResponse!, error : NSError!) in
            if searchResponse != nil && searchResponse.mapItems != nil {
                for item in searchResponse.mapItems {
                    self.searchResults.append(item as MKMapItem)
                }
            }
            self.tableView!.reloadData()
        })
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        if indexPath.row == 0 {
            cell.textLabel!.text = "Current Location"
        } else {
            var mapItem : MKMapItem = searchResults[indexPath.row - 1]
            cell.textLabel!.text = mapItem.name
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var locationString = "Current Location"
        var location : MKMapItem?
        if indexPath.row != 0 {
            locationString = searchResults[indexPath.row - 1].name
            location = searchResults[indexPath.row - 1]
        }
        if fromLocationString == nil {
            fromLocationString = locationString
            fromLocation = location
            textFieldFrom?.text = fromLocationString
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            textFieldTo?.becomeFirstResponder()
            searchResults.removeAll()
            tableView.reloadData()
        } else {
            toLocationString = locationString
            toLocation = location
            textFieldTo?.text = toLocationString
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            searchResults.removeAll()
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: {
                self.delegate?.fromLocation = self.fromLocation
                self.delegate?.toLocation = self.toLocation
                self.delegate?.userEnteredFromToLocation()
            })
        }
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
