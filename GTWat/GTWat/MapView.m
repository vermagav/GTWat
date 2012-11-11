//
//  MapView.m
//  GTWat
//
//  Created by Kevin Hampton on 11/4/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) longPressOccurred: (UIGestureRecognizer*) recognizer {
  NSLog(@"Long Press");
}

@end
