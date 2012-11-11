//
//  MapView.h
//  GTWat
//
//  Created by Kevin Hampton on 11/4/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : MKMapView

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer;

@end
