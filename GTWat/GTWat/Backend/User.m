//
//  User.m
//  GTWat
//
//  Created by Kevin Hampton on 11/17/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId;

-(id) initWithUserId: (int) uId withLastLoc:(NSString*) loc {
  self = [super init];
  
  _userId = uId;
  _lastKnownLocation = loc;
  
  
  return self;
}

+(id) userWithJSONEntry:(NSDictionary*) jsonElement {
  
  int uId = (int)[jsonElement objectForKey:@"userId"];
  NSString* lastLoc = [jsonElement objectForKey:@"lastKnownLoc"];
  
  User* newUser = [[User alloc] initWithUserId:uId withLastLoc:lastLoc];
  return newUser;
  
}

@end
