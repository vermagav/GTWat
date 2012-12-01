//
//  DataViewController.h
//  GTWat
//
//  Created by Kevin Hampton and Brian Tan Sun on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DataViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate> {
  IBOutlet UINavigationBar* navBar;
  IBOutlet UITextField* subject;
  IBOutlet UIScrollView* scrollView;
  MKPointAnnotation* pin;
  MKMapView* map;
}

-(void) getStared:(MKPointAnnotation*) pa with: (MKMapView *) mapView;

-(IBAction)done:(id)sender;

@end
