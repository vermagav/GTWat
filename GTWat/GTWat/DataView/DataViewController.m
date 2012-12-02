//
//  DataViewController.m
//  GTWat
//
//  Created by Kevin Hampton and Brian Tan Sun on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "DataViewController.h"
#import "ChoosePinTypeViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

@synthesize selectedPinType;

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
  navBar.topItem.title = @"New Post";
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  // For selecting cell.
  gestureRecognizer.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:gestureRecognizer];
  [gestureRecognizer release];

}

-(IBAction)cancel:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)done:(id)sender {
  UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"Share Your Post"
                                                      message:@"Would you like to share this post on your Social Network?"
                                                     delegate:self
                                            cancelButtonTitle:@"No Thanks."
                                            otherButtonTitles:@"Yes, Please!", nil];
  [shareAlert show];
  [shareAlert release];
}

- (void)getStared: (MKPointAnnotation *) pa with: (MKMapView *) mapView{
  pin = pa;
  map = mapView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  if ([title isEqualToString:@"Yes, Please!"]){
      NSString *textToShare = @"test!"; //Change what we share here.
      NSArray *activityItems = @[textToShare];
      UIActivityViewController *activityVC =
      [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                        applicationActivities:nil];
      [self presentViewController:activityVC animated:YES completion:nil];
  }
  [pin setTitle:[subject text]]; //update the pin;
  [map selectAnnotation:pin animated:YES];
  [self.navigationController popToRootViewControllerAnimated:YES];

}


//Move Keyboard
-(IBAction) slideFrameUp1;
{
  [self slideFrame:YES with:50];
}
-(IBAction) slideFrameUp2;
{
  [self slideFrame:YES with:110];
}

-(IBAction) slideFrameDown1;
{
  [self slideFrame:NO with: 50];
}
-(IBAction) slideFrameDown2;
{
  [self slideFrame:NO with: 110];
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
  scrollView.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}

//Hide Keyboard
- (void) hideKeyboard {
  [self.view endEditing:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController* destination = [segue destinationViewController];
  
  if([destination isKindOfClass: [ChoosePinTypeViewController class]]) {
    ChoosePinTypeViewController* pinView = [segue destinationViewController];
    [pinView setDataController:self];
  }
  else {
    
  }
}

@end
