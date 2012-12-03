//
//  SettingsViewController.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"
#import "SyncHelper.h"
#import "ViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize mainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  int uid = [Utilities getUserId];
  NSString* idStr = [NSString stringWithFormat:@"%d", uid];
  [idLabel setText:idStr];
  if (!_showAlerts){
    [alertSwitch setOn:(FALSE)];
  }
  if (!_showEvents){
    [eventSwitch setOn:(FALSE)];
  }
  if (!_showQuestions){
    [questionSwitch setOn:(FALSE)];
  }
	// Do any additional setup after loading the view.
}

-(IBAction)switchAlerts:(id)sender {
  [mainView setShowAlerts: [alertSwitch isOn]];
}
-(IBAction)switchQuestions:(id)sender {
  [mainView setShowQuestions: [questionSwitch isOn]];
}
-(IBAction)switchEvents:(id)sender {
  [mainView setShowEvents: [eventSwitch isOn]];
}

-(IBAction)done:(id)sender {
  [mainView refreshPins];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)forceSync:(id)sender {
  SyncHelper* data = [SyncHelper getSyncHelper];
  [data syncCache];
}

-(IBAction)restoreApp:(id)sender {
  int uid = [Utilities forceNewId];
  NSString* idStr = [NSString stringWithFormat:@"%d", uid];
  [idLabel setText:idStr];
  
  [questionSwitch setOn:YES];
  [alertSwitch setOn:YES];
  [eventSwitch setOn:YES];
  
  SyncHelper* data = [SyncHelper getSyncHelper];
  [data sync:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
