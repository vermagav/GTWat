//
//  ViewController.m
//  GTWat
//
//  Created by Gav Verma on 10/23/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "ViewController.h"
#import "DataViewController.h"
#import "SyncHelper.h"
#import "Utilities.h"
#import "Pin.h"
#import "Comment.h"
#import "User.h"
#import "SettingsViewController.h"

#import <CoreLocation/CLLocation.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize showAlerts = _showAlerts, showEvents = _showEvents, showQuestions = _showQuestions;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  userId = [Utilities loadUserId];
  dataSource = [SyncHelper getSyncHelper];

  UILongPressGestureRecognizer* longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOccurred:)];
  [mapView addGestureRecognizer:longPressRec];
  [longPressRec release];	

  // Initialize map view observer for zooming to user location
  [self->mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:nil];
    
  // Create object to manage location service
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
  // Set the delegate for the location manager
  locationManager.delegate = self;

  // Set your desired accuracy
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

  [locationManager startUpdatingLocation];
  
  // Set default region to Georgia Tech campus
  // Hard coded for now, replace with user location if app is used elsewhere
  currLocation = [[CLLocation alloc] initWithLatitude:33.778463 longitude:-84.398881];
  MKCoordinateRegion region;
  region.center = currLocation.coordinate; // = self->mapView.userLocation.coordinate;
  
  // Set zoom level
  MKCoordinateSpan span;
  span.latitudeDelta  = 0.015;
  span.longitudeDelta = 0.015;
  region.span = span;
  
  // Change default map view to above
  [self->mapView setRegion:region animated:YES];
  
  // Show user location (blue dot)
  self->mapView.showsUserLocation = YES;
  
  [self loadPins];
  [self getCommentsForPin:1494771517];

}

-(void) loadPins {
  
  Cache* cache = [Cache getCacheInst];
  
  NSMutableDictionary* pinDict;
  [cache readPinsFromDB:&pinDict];
  NSArray* keys = [pinDict allKeys];
  for(int i = 0; i < [keys count]; i++) {
    NSNumber* key = [keys objectAtIndex:i];
    Pin* pin = [pinDict objectForKey:key];
    
    NSString* locationStr = [pin location];
    NSArray* locArray = [locationStr componentsSeparatedByString:@","];
    NSString* longitudeStr = [locArray objectAtIndex:0];
    NSString* latStr = [locArray objectAtIndex:1];
    
    double longitude = [longitudeStr doubleValue];
    double latitude = [latStr doubleValue];
    
    CLLocation* pinLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    MKPointAnnotation* pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = pinLocation.coordinate;
    pa.title = [pin subject];
    [mapView addAnnotation:pa];
  }
  
}

/*
  Get matching comments
 */
-(NSMutableArray*) getCommentsForPin:(int) entryIdParam {

  // Create NSMutableArray to populate and return later
  NSMutableArray* matchingComments = [[NSMutableArray alloc] init];

  // Load comments from cache
  NSMutableDictionary* commentsDict;
  Cache* cache = [Cache getCacheInst];
  [cache readCommentsFromDB:&commentsDict];
  NSArray* keys = [commentsDict allKeys];
  
  // Iterate through all comments
  for(int i = 0; i < [keys count]; i++) {
    NSNumber* key = [keys objectAtIndex:i];
    Comment* comment = [commentsDict objectForKey:key];
    
    // Find matching comment(s) and add object to our array
    if(comment.entryId == entryIdParam) {
      [matchingComments addObject:comment];
    }
  }
  
  // Return matching comments
  return matchingComments;
}

-(void) addNewPin:(Pin*) pin {
  [pin setAnnotationView:newPin];
  [mapView setNeedsDisplay];
  newPin = nil;
}

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer {
  NSLog(@"Long Press");

  if(recognizer.state == UIGestureRecognizerStateEnded) {
    CGPoint touchPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    //MKCircle *circle = [MKCircle circleWithCenterCoordinate:touchMapCoordinate radius:1];
    //[mapView addOverlay:circle];
    
    newPin = [[MKPointAnnotation alloc] init];
    
    newPin.coordinate = touchMapCoordinate;
    newPin.title = @"Hello";
    //[mapView addAnnotation:pa];
    
    [self performSegueWithIdentifier:@"PinSegue" sender:self];
  }
}

/*- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
  MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
  circleView.strokeColor = [UIColor redColor];
  circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
  return [circleView autorelease];
}*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  UIViewController* destination = [segue destinationViewController];
  if([destination isKindOfClass: [DataViewController class]]) {
    DataViewController* upcomingDataView = [segue destinationViewController];
    [upcomingDataView getStared:newPin with:mapView];
    [upcomingDataView setCurrLocation:currLocation];
  }
  else {
    SettingsViewController* settingsController = (SettingsViewController*) [segue destinationViewController];
    [settingsController setMainView:self];
  }
}

-(BOOL) showEvents {
  return _showEvents;
}

-(void) setShowEvents:(BOOL)sEvents {
  _showEvents = sEvents;
  [mapView setNeedsDisplay];
  [[self view] setNeedsDisplay];
}

-(BOOL) showAlerts {
  return _showAlerts;
}

-(void) setShowAlerts:(BOOL)sAlerts {
  _showAlerts = sAlerts;
  [mapView setNeedsDisplay];
  [[self view] setNeedsDisplay];
}

-(BOOL) showQuestions {
  return _showQuestions;
}

-(void) setShowQuestions:(BOOL)sQuestions {
  _showQuestions = sQuestions;
  [mapView setNeedsDisplay];
  [[self view] setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Listen for a change in userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
 // Unused atm
}

// Cleanup for user location code
- (void)dealloc
{
    [self->mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [self->mapView removeFromSuperview]; // release crashes app
     self->mapView = nil;
    [super dealloc];
}

@end

