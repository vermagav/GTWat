//
//  PinAnnotationView.h
//  GTWat
//
//  Created by Kevin Hampton on 12/2/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Pin;

@interface PinAnnotationView : MKPointAnnotation {

}

@property (nonatomic, retain) Pin* pin;

@end
