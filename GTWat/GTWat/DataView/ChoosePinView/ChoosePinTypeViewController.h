//
//  ChoosePinTypeViewController.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ChoosePinTypeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

  IBOutlet UIPickerView* pinPicker;
  NSArray* pinTypes;
  
  IBOutlet UITableView* table;
  
  IBOutlet UITextView* description;
}

@property (nonatomic, retain) DataViewController* dataController;

-(IBAction)done:(id)sender;

@end
