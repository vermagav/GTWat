//
//  ViewController.h
//  GTWat
//
//  Created by Gav Verma on 10/23/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController {
  NSTimer* pressTimer;
  
  IBOutlet MKMapView* mapView;
}

@end
