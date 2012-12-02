//
//  DataViewController.h
//  GTWat
//
//  Created by Kevin Hampton and Brian Tan Sun on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef enum PinType {
  Question,
  Alert,
  Event
} PinType;

@interface DataViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate> {
  IBOutlet UINavigationBar* navBar;
  
  IBOutlet UITextField* subject;
  IBOutlet UITextField* location;
  IBOutlet UITextField* time;
  IBOutlet UITextView* description;

  IBOutlet UIScrollView* scrollView;
  MKPointAnnotation* pin;
  IBOutlet MKMapView* map;
  
  UIPopoverController* popover;
  
  PinType _selectedPinType;
}

@property PinType selectedPinType;

-(void) getStared:(MKPointAnnotation*) pa with: (MKMapView *) mapView;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
