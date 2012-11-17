//
//  User.h
//  GTWat
//
//  Created by Kevin Hampton on 11/17/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
  int _userId;
  NSString* _lastKnownLocation;
}

-(id) initWithUserId: (int) uId withLastLoc:(NSString*) loc;

+(id) userWithJSONEntry:(NSDictionary*) jsonElement;

@property int userId;

@end
