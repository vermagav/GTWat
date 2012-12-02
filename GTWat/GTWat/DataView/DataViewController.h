//
//  DataViewController.h
//  GTWat
//
//  Created by Kevin Hampton and Brian Tan Sun on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

typedef enum PinType {
  Question,
  Alert,
  Event
} PinType;

@interface DataViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
  IBOutlet UINavigationBar* navBar;
  
  IBOutlet UITextField* subject;
  IBOutlet UITextField* location;
  IBOutlet UITextField* time;
  IBOutlet UITextView* description;
  IBOutlet UIButton* changePinTypeButton;

  IBOutlet UIScrollView* scrollView;
  MKPointAnnotation* pin;
  IBOutlet MKMapView* map;
  
  NSArray* pinTypes;
  
  PinType _selectedPinType;
  
  CLLocation* _currLocation;
}

@property PinType selectedPinType;

@property(nonatomic, retain) CLLocation* currLocation;

-(void) getStared:(MKPointAnnotation*) pa with: (MKMapView *) mapView;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changePinType:(id)sender;

@end
