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

@interface ViewController ()

@end

@implementation ViewController

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
}

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer {
  NSLog(@"Long Press");
  
  if(recognizer.state == UIGestureRecognizerStateEnded) {
    CGPoint touchPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    pa = [[MKPointAnnotation alloc] init];
    
    pa.coordinate = touchMapCoordinate;
    pa.title = @"Hello";
    [mapView addAnnotation:pa];
    [self performSegueWithIdentifier:@"PinSegue" sender:self];
  }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  UIViewController* destination = [segue destinationViewController];
  if([destination isKindOfClass: [DataViewController class]]) {
    DataViewController* upcomingDataView = [segue destinationViewController];
    [upcomingDataView getStared:pa with:mapView];
  }
  else {
    
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    MKCoordinateRegion region;
    region.center = self->mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.5; // Change these values to change the zoom
    span.longitudeDelta = 0.5;
    region.span = span;
    
    [self->mapView setRegion:region animated:YES];
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
