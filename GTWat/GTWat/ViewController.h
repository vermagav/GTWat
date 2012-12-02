//
//  ViewController.h
//  GTWat
//
//  Created by Gav Verma on 10/23/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DataViewController;
@class SyncHelper;

@interface ViewController : UIViewController {
  NSTimer* pressTimer;
  
  SyncHelper* dataSource;
  
  int userId;
  
  IBOutlet MKMapView* mapView;
  IBOutlet DataViewController* dvc;
  
  MKPointAnnotation* newPin;
  
  BOOL _showAlerts;
  BOOL _showQuestions;
  BOOL _showEvents;
}

@property BOOL showAlerts;
@property BOOL showEvents;
@property BOOL showQuestions;

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer;

@end
