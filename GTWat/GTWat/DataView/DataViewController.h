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

@interface DataViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
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
  
  UIPopoverController* popover;
  UIActionSheet *actionSheet;
  
  PinType _selectedPinType;
}

@property PinType selectedPinType;

-(void) getStared:(MKPointAnnotation*) pa with: (MKMapView *) mapView;
-(void) dismissActionSheet;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changePinType:(id)sender;

@end
