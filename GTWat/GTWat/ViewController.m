//
//  ViewController.m
//  GTWat
//
//  Created by Gav Verma on 10/23/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "ViewController.h"
#import "DataViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  UILongPressGestureRecognizer* longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:mapView action:@selector(longPressOccurred)];
  longPressRec.minimumPressDuration = 2.0;
  [mapView addGestureRecognizer:longPressRec];
  [longPressRec release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
