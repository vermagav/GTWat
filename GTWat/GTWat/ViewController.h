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
@class Pin;
@class PinAnnotationView;

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
  NSTimer* pressTimer;
  
  SyncHelper* dataSource;
  
  int userId;
  
  IBOutlet MKMapView* mapView;
  IBOutlet DataViewController* dvc;
  
  PinAnnotationView* newPin;
  PinAnnotationView* selectedPin;
  NSArray* paArrays;
  
  BOOL _showAlerts;
  BOOL _showQuestions;
  BOOL _showEvents;
  
  CLLocation* currLocation;
  
  NSMutableArray* displayPins;
  
  CLLocation* touchLoc;
}

@property BOOL showAlerts;
@property BOOL showEvents;
@property BOOL showQuestions;

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer;
-(void) addNewPin:(Pin*) pin;
-(void) loadPins;
-(void) refreshPins;
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation;

@end
