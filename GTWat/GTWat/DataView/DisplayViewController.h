//
//  DisplayViewController.h
//  GTWat
//
//  Created by Kevin Hampton on 12/2/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Pin;

@interface DisplayViewController : UIViewController <UITextViewDelegate> {
  IBOutlet MKMapView* map;
  
  IBOutlet UILabel* subjectLabel;
  IBOutlet UITextView* descLabel;
  IBOutlet UILabel* locationLabel;
  IBOutlet UILabel* time;
  IBOutlet UIScrollView* scrollView;
  
  IBOutlet UINavigationBar* navBar;
  
  NSArray* comments;
}

@property (nonatomic, retain) Pin* pin;

-(IBAction)done:(id)sender;
-(void) displayComments;

@end
