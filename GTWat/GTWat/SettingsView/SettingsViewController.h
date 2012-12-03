//
//  SettingsViewController.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface SettingsViewController : UIViewController {
  IBOutlet UILabel* idLabel;
  
  IBOutlet UISwitch* questionSwitch;
  IBOutlet UISwitch* alertSwitch;
  IBOutlet UISwitch* eventSwitch;
}

@property(nonatomic, retain) ViewController* mainView;
@property BOOL showAlerts;
@property BOOL showEvents;
@property BOOL showQuestions;

-(IBAction)done:(id)sender;

-(IBAction)forceSync:(id)sender;
-(IBAction)restoreApp:(id)sender;

@end
