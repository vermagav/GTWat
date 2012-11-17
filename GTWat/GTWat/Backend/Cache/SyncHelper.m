//
//  SyncHelper.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "SyncHelper.h"
#import "User.h"
#import "Utilities.h"

#define SYNCMINS 10

@implementation SyncHelper

- (id) init {
  self = [super init];
  
  NSString* dbPath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];
  
  cache = [[Cache alloc] initWithDatabase:dbPath];
  
  syncTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sync:) userInfo:nil repeats:YES];
  
  return self;
}

-(void) sync:(NSTimer*) timer {
  NSLog(@"Syncing");

  [self performSelectorInBackground:@selector(syncCache) withObject:nil];
}

-(void) syncCache {
  NSLog(@"I am in the background. :O");
  
  cachedUsers = [self requestUsers];
  
  lastSynced = [NSDate date];
}

-(NSDictionary*) requestUsers {
  
  //Build storing type
  NSMutableDictionary* users = [[NSMutableDictionary alloc] init];
  
  //Build request url + types
  NSURL* url = [NSURL URLWithString:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users"];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSError* requestError;
  NSURLResponse* response;
  
  //Make request
  NSData* requestData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
  
  //Parse request
  NSError* jsonError;
  NSArray* json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:& jsonError];
  
  for(int i = 0; i < [json count]; i++) {
    NSDictionary* thingy = [json objectAtIndex:i];
    User* user = [User userWithJSONEntry:thingy];
    int userId = [user userId];
    [users setObject:user forKey:[NSNumber numberWithInt: userId]];
  }
  
  //Return resulting type
  return users;
}

-(User*) requestUserWithId:(int) uId {
  
  //Build request url + types
  NSString* uIdStr = [NSString stringWithFormat:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/?userId=%d", uId];
  NSURL* url = [NSURL URLWithString:uIdStr];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSError* requestError;
  NSURLResponse* response;
  
  //Make request
  NSData* requestData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
  
  //Parse request
  NSError* jsonError;
  NSArray* json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:& jsonError];

  
  User* user = nil;
  
  if([json count] == 1) {
    NSDictionary* userElem = [json objectAtIndex:0];
    [User userWithJSONEntry:userElem];
  }
  
  //Return resulting type
  return user;
}

-(BOOL) createUserWithId:(int) uId withCurrentLocation:(NSString*) location {
  NSString* urlStr = @"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/";
  NSString* uIdStr = [NSString stringWithFormat:@"?userId=%d", uId];
  urlStr = [urlStr stringByAppendingString:uIdStr];
  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  
  return false;
}

-(BOOL) updateCurrentPositionWithLocation:(NSString*) location {
  int uId = [Utilities getUserId];
  return [self updateUserLocationWithId:uId withLocation:location];
}

-(BOOL) updateUserLocationWithId:(int) uId withLocation: (NSString*) location {
  
  NSString* urlStr = @"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/";
  NSString* uIdStr = [NSString stringWithFormat:@"?userId=%d", uId];
  urlStr = [urlStr stringByAppendingString:uIdStr];
  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"PUT"];
  
  return NO;
}

@end
