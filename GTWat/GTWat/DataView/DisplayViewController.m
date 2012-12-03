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

-(void) viewDidLayoutSubviews {
  [self viewDidLoad];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  [self.view addGestureRecognizer:gestureRecognizer];
  [gestureRecognizer release];
  NSString* subject = [pin subject];
  NSString* description = [pin description];
  NSString* specLoc = [pin specificLocation];
  NSDate* date = [pin date];
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString* dateStr = [dateReader stringFromDate:date];
  gestureRecognizer.cancelsTouchesInView = NO;
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
  
  [self displayComments];
  
	// Do any additional setup after loading the view.
}

-(void) displayComments {
  
  int commentStartX = 20;
  int commentStartY = 485;
  
  int commentWidth = 280;
  int commentHeight = 80;
  
  int maxHeight = 80;
  
  int borderThickness = 2;
  
  CGRect border = CGRectMake(commentStartX-borderThickness, commentStartY-borderThickness, commentWidth+2*borderThickness, commentHeight+2*borderThickness);
  UIView* bview = [[UIView alloc] initWithFrame:border];
  [bview setBackgroundColor:[UIColor darkGrayColor]];
  [self->scrollView addSubview:bview];
  
  CGRect rect = CGRectMake(commentStartX, commentStartY, commentWidth, commentHeight);
  UITextView* textView = [[UITextView alloc] initWithFrame:rect];
  [textView setText:@"YAY"];
  
  [scrollView addSubview:textView];
  
  CGSize size = scrollView.frame.size;
  
  NSLog(@"ScrollView size: %f %f", size.width, size.height);
  size.width = 320;
  size.height = 504+400;
  
  CGSize mainViewSize = self.view.frame.size;
  float width = mainViewSize.width;
  float height = mainViewSize.height;
  
  CGSize newScrollSize = CGSizeMake(width, size.height+maxHeight+20);
  
  [scrollView setFrame:CGRectMake(0, 40, 320, 504)];
  [scrollView setContentSize:newScrollSize];
  
  //[[self view] autoresizesSubviews];
}

-(IBAction)done:(id)sender {
  [[self navigationController] popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  [self slideFrame:YES with:210];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  [self slideFrame:NO with:210];
}

-(void) slideFrame:(BOOL) up with: (int) dist
{
  const int movementDistance = dist; // tweak as needed
  const float movementDuration = 0.3f; // tweak as needed
  
  int movement = (up ? -movementDistance : movementDistance);
  
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  scrollView.frame = CGRectOffset(scrollView.frame, 0, movement);
  [UIView commitAnimations];
}

//Hide Keyboard
- (void) hideKeyboard {
  [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
