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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  userId = [Utilities loadUserId];
  dataSource = [[SyncHelper alloc] init];

  UILongPressGestureRecognizer* longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOccurred:)];
  [mapView addGestureRecognizer:longPressRec];
  [longPressRec release];
}

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer {
  NSLog(@"Long Press");
  
  if(recognizer.state == UIGestureRecognizerStateEnded) {
    CGPoint touchPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    MKPointAnnotation* pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = touchMapCoordinate;
    pa.title = @"Hello";
    [mapView addAnnotation:pa];
    [pa release];
    [self performSegueWithIdentifier:@"PinSegue" sender:self];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
