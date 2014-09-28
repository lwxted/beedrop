//
//  MapViewController.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    var mapView : MKMapView?

    func setupMapView() {
        var latitude : CLLocationDegrees = 40.44239536653566
        var longtitude : CLLocationDegrees = -79.9457530
        var latDelta : CLLocationDegrees = 0.01
        var longDelta : CLLocationDegrees = 0.01
        var span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var loc : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        var region : MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        
        mapView = MKMapView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        mapView!.setRegion(region, animated: true)
        view.addSubview(mapView!)
    }
    
    func invokeStatusView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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