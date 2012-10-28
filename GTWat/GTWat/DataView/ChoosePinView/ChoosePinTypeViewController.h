//
//  ChoosePinTypeViewController.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePinTypeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

  IBOutlet UIPickerView* pinPicker;
  NSArray* pinTypes;
  
  IBOutlet UITextView* description;
}

-(IBAction)done:(id)sender;

@end
