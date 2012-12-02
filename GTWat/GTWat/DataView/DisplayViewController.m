//
//  DisplayViewController.m
//  GTWat
//
//  Created by Kevin Hampton on 12/2/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "DisplayViewController.h"
#import "Pin.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

@synthesize pin;

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
  NSString* subject = [pin subject];
  NSString* description = [pin description];
  NSString* specLoc = [pin specificLocation];
  NSDate* date = [pin date];
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString* dateStr = [dateReader stringFromDate:date];
  
  NSString* type = NSStringFromClass([description class]);
  NSLog(@"Type: %@", type);
  
  [subjectLabel setText:subject];
  [descLabel setText:description];
  [locationLabel setText:specLoc];
  [time setText:dateStr];
  
  int pinType = [pin pinType];
  NSString* pinTypeStr = @"";
  switch (pinType) {
    case 0:
      pinTypeStr = @"Question";
      break;
    case 1:
      pinTypeStr = @"Alert";
      break;
    case 2:
      pinTypeStr = @"Event";
      break;
  }
  navBar.topItem.title = pinTypeStr;
  
  comments = [pin comments];
  
  NSString* locationStr = [pin location];
  NSArray* locArray = [locationStr componentsSeparatedByString:@","];
  NSString* longitudeStr = [locArray objectAtIndex:0];
  NSString* latStr = [locArray objectAtIndex:1];
  
  double longitude = [longitudeStr doubleValue];
  double latitude = [latStr doubleValue];
  
  CLLocation* pinLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
  
  MKCoordinateRegion region;
  region.center = pinLocation.coordinate;
  // Set zoom level
  MKCoordinateSpan span;
  span.latitudeDelta  = 0.005;
  span.longitudeDelta = 0.005;
  region.span = span;
  
  // Change default map view to above
  [map setRegion:region animated:YES];
  
	// Do any additional setup after loading the view.
}

-(IBAction)done:(id)sender {
  [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
