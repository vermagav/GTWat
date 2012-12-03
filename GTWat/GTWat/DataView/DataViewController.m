//
//  DataViewController.m
//  GTWat
//
//  Created by Kevin Hampton and Brian Tan Sun on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "DataViewController.h"
#import "ChoosePinTypeViewController.h"
#import "ViewController.h"
#import "Utilities.h"
#import "Pin.h"

@interface DataViewController ()

@end

@implementation DataViewController

@synthesize selectedPinType = _selectedPinType;
@synthesize currLocation = _currLocation;
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
  navBar.topItem.title = @"New Post";
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSheet) name:UIApplicationWillResignActiveNotification object:nil];
  UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  // For selecting cell.
  gestureRecognizer.cancelsTouchesInView = NO;
  pinTypes = [[NSArray alloc] initWithObjects:@"Question", @"Alert", @"Event", nil];
  [self.view addGestureRecognizer:gestureRecognizer];
  [gestureRecognizer release];

  MKCoordinateRegion region;
  region.center = pin.coordinate; // = self->mapView.userLocation.coordinate;
  [map addAnnotation:pin];
  // Set zoom level
  MKCoordinateSpan span;
  span.latitudeDelta  = 0.005;
  span.longitudeDelta = 0.005;
  region.span = span;
  isTypeSelected = false;
  chosenDate = nil;
  currentOffset = 0;
  
  // Change default map view to above
  [map setRegion:region animated:YES];
  
}

-(IBAction)cancel:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)changePinType:(id)sender {
  actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
  
  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  
  CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
  
  UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
  pickerView.showsSelectionIndicator = YES;
  pickerView.dataSource = self;
  pickerView.delegate = self;
  
  [actionSheet addSubview:pickerView];
  [pickerView release];
  
  UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
  closeButton.momentary = YES;
  closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
  closeButton.tintColor = [UIColor blackColor];
  [closeButton addTarget:actionSheet action:@selector(dismissWithClickedButtonIndex: animated: ) forControlEvents:UIControlEventValueChanged];
  [actionSheet addSubview:closeButton];
  //[closeButton release];
  
  [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  
  [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
  [changePinTypeButton setTitle:@"Pin Type: Questions" forState:(UIControlStateNormal)];
  _selectedPinType = 0;
  isTypeSelected = true;
}

- (IBAction)getDate:(id)sender {
  actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:nil
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil];
  
  [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  
  CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
  
  datePickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
  datePickerView.minimumDate = [NSDate date];
  
  [actionSheet addSubview:datePickerView];
  
  UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
  closeButton.momentary = YES;
  closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
  closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
  closeButton.tintColor = [UIColor blackColor];
  [closeButton addTarget:actionSheet action:@selector(dismissWithClickedButtonIndex: animated: ) forControlEvents:UIControlEventValueChanged];
  actionSheet.delegate=self;
  [actionSheet addSubview:closeButton];
  [closeButton release];
  
  [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
  
  [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"MMM d, YYYY HH:mm"];
  NSString *dateString = [dateFormat stringFromDate:datePickerView.date];
  chosenDate= [[NSDate alloc] initWithTimeInterval:0 sinceDate:datePickerView.date];
  [time setText:dateString];
  [self.view endEditing:YES];
}
/*
- (void) dismissActionSheet:(id)sender {
  [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
  [actionSheet release];
  [datePickerView release];
  NSString* jsCallback = [NSString stringWithFormat:@"window.plugins.datePicker._dateSelected(\"%i\");", (int)[datePickerView.date timeIntervalSince1970]];
  NSLog(jsCallback);
}
 */

- (IBAction)done:(id)sender {
  
  NSString* desc = [description text];
  NSString* locationStr = [location text];
  //NSString* timeStr = [time text];
  NSString* subjectStr = [subject text];
  int uId = [Utilities getUserId];
   
  if (![self checkDescription]|| [subjectStr isEqualToString:@""] || !isTypeSelected){
    UIAlertView * emptyAlert = [[UIAlertView alloc] initWithTitle:@"Empty Field"
                                                         message:@"Please enter subject, description and type of your Pin."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK."
                                               otherButtonTitles:nil];
    [emptyAlert show];
    [emptyAlert release];
    
  }else{
  
    double latitude = _currLocation.coordinate.latitude;
    double longitude = _currLocation.coordinate.longitude;
    NSString* locStr = [NSString stringWithFormat:@"%f,%f", longitude, latitude ];
  
    NSDate* currDate = [NSDate date];
    NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate* eventDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:datePickerView.date];
    
    Pin* newPin = [[Pin alloc] initWithEntryId:NULL withUserId:uId withSubject:subjectStr withDescription:desc withLocation:locStr withSpecLocation:locationStr withDate:chosenDate withAddDate:currDate withPinType: _selectedPinType];
  
  
    [mainView addNewPin:newPin];
  
    UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"Share Your Post"
                                                        message:@"Would you like to share this post on your Social Network?"
                                                        delegate:self
                                              cancelButtonTitle:@"No Thanks."
                                              otherButtonTitles:@"Yes, Please!", nil];
    [shareAlert show];
    [shareAlert release];
  }
}

- (void)getStared: (MKPointAnnotation *) pa with: (MKMapView *) mapView{
  pin = pa;
  map = mapView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  if ([title isEqualToString:@"Yes, Please!"]){
    NSString *textToShare = [NSString stringWithFormat:@"I just posted a new %@ on GTWat: %@!", [self typeString],[subject text]]; //Change what we share here.
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
  [self slideFrame:NO with:0];
}
-(IBAction) slideFrameDown2;
{
  [self slideFrame:NO with:0];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  if (![self checkDescription]) [description setText:@""];
  [self slideFrame:YES with:210];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  [self slideFrame:NO with:0];
}

-(void) slideFrame:(BOOL) up with: (int) dist
{
  const int movementDistance = dist; // tweak as needed
  const float movementDuration = 0.3f; // tweak as needed
  
  int movement = (up ? -movementDistance : movementDistance);
  
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  if (movement!=currentOffset)
    scrollView.frame = CGRectOffset(scrollView.frame, 0, (movement - currentOffset));
  currentOffset = movement;
  [UIView commitAnimations];
}

-(void)resetFrame: (int) move{
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  const float movementDuration = 0.3f; // tweak as needed
  [UIView setAnimationDuration: movementDuration];
  scrollView.frame = CGRectOffset(scrollView.frame, 0, move);
  [UIView commitAnimations];
}

//Hide Keyboard
- (void) hideKeyboard {
  [self.view endEditing:YES];
}

// Pikcer
#pragma mark PickerView DataSource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [pinTypes count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [pinTypes objectAtIndex: row];
}

#pragma mark PickerView Delegate

- (void)pickerView:(UIPickerView *)PickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  NSLog(@"Selected Type: %@. Index of selected type: %i", [pinTypes objectAtIndex:row], row);
  [changePinTypeButton setTitle:[NSString stringWithFormat:@"Pin Type: %@", [pinTypes objectAtIndex:row]] forState:UIControlStateNormal];
  _selectedPinType = row;
}

- (Boolean) checkDescription{
  if ([description.text isEqualToString:@"Description goes here!"] || [description.text isEqualToString:@""])
    return false;
  else
    return true;
}

- (NSString*) typeString{
  switch (_selectedPinType) {
    case Question:
      return @"Question";
      break;
    case Alert:
      return @"Alert";
    case Event:
      return @"Event";
    default:
      break;
  }
                               
}
                             
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
  [super dealloc];
}
@end
