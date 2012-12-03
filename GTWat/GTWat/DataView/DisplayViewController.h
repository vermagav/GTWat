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
  IBOutlet UILabel* addtime;
  IBOutlet UILabel* time;
  IBOutlet UIScrollView* scrollView;
  
  IBOutlet UITextView* newCommentTextView;
  
  IBOutlet UINavigationBar* navBar;
  int currentOffset;
  
  NSMutableArray* comments;
}

@property (nonatomic, retain) Pin* pin;

-(IBAction)done:(id)sender;
-(void) displayComments;

-(IBAction)addComment:(id)sender;

@end
