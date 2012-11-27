//
//  SyncHelper.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "SyncHelper.h"
#import "User.h"
#import "Pin.h"
#import "Comment.h"
#import "Utilities.h"

#define SYNCMINS 10

@implementation SyncHelper

+(SyncHelper*) getSyncHelper {
  if(!syncInst) {
    syncInst = [[SyncHelper alloc] init];
  }
  return syncInst;
}

- (id) init {
  self = [super init];
  
  NSString* dbPath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];
  
  cache = [[Cache alloc] initWithDatabase:dbPath];
  
  [self syncCache];
  
  syncTimer = [NSTimer scheduledTimerWithTimeInterval:SYNCMINS*60 target:self selector:@selector(sync:) userInfo:nil repeats:YES];
  
  return self;
}

-(void) sync:(NSTimer*) timer {
  NSLog(@"Syncing");

  [self performSelectorInBackground:@selector(syncCache) withObject:nil];
}

-(void) syncCache {
  _isWritingToCache = YES;
  
  cachedUsers = [self requestUsers];
  cachedComments = [self requestComments];
  cachedPins = [self requestPins];
  
  [cache clearUsersFromDB];
  [cache clearCommentsFromDB];
  [cache clearPinsFromDB];
  
  [cache writeUsersToDB:cachedUsers];
  [cache writeCommentsToDB:cachedComments];
  [cache writePinssToDB:cachedPins];
  
  _isWritingToCache = NO;
  lastSynced = [NSDate date];
}

-(BOOL) isWritingToCache {
  return _isWritingToCache;
}

#pragma mark Comments helper methods

-(NSDictionary*) requestComments {
  //Build storing type
  NSMutableDictionary* comments = [[NSMutableDictionary alloc] init];
  
  //Build request url + types
  NSURL* url = [NSURL URLWithString:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/comments"];
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
    Comment* comment = [Comment commentWithJSONEntry:thingy];
    [comments setObject:comment forKey:[NSNumber numberWithInt:[comment commentId]]];
  }
  
  //Return resulting type
  return comments;
}

-(Comment*) requestCommentWithCommentId:(int) commentId {

  //Build request url + types
  NSString* urlStr = [NSString stringWithFormat:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/comments/%d", commentId];

  NSURL* url = [NSURL URLWithString:urlStr];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSError* requestError;
  NSURLResponse* response;
  
  //Make request
  NSData* requestData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
  
  //Parse request
  NSError* jsonError;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:& jsonError];
  
  Comment* comment = nil;
  comment = [Comment commentWithJSONEntry:json];
  
  //Return resulting type
  return comment;
}

-(BOOL) addComment:(Comment*) comment {
  int commendId = [comment commentId];
  int entryId = [comment entryId];
  int userId = [comment userId];
  NSString* text = [comment text];
  NSDate* date = [comment date];
 
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString* dateStr = [dateReader stringFromDate:date];
  
  //Build Variable string and Data
  NSString* postStr = [NSString stringWithFormat:@"entryId=%d&userId=%d&commentId=%d&text=%@&time=%@&", entryId, userId, commendId, text, dateStr];
  
  NSData* postData = [postStr dataUsingEncoding:NSASCIIStringEncoding];
  NSString* postDataLen = [NSString stringWithFormat:@"%d", [postData length]];
  
  //Build request
  NSString* urlStr = @"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/comments/";
  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:postDataLen forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  [request setTimeoutInterval:30];
  
  //Send request
  NSError* error;
  NSURLResponse* response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if (error) {
    return NO;
  }
  
  return YES;
}

#pragma mark Pin helper methods
-(NSDictionary*) requestPins {
  //Build storing type
  NSMutableDictionary* pins = [[NSMutableDictionary alloc] init];
  
  //Build request url + types
  NSURL* url = [NSURL URLWithString:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/pins"];
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
    Pin* pin = [Pin pinWithJSONEntry:thingy];
    [pins setObject:pin forKey:[NSNumber numberWithInt:[pin entryId]]];
  }
  
  //Return resulting type
  return pins;

}

-(Pin*) requestPinWithEntryId:(int) entryId {
  //Build storing type
  
  //Build request url + types
  NSString* urlStr = [NSString stringWithFormat:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/pins/%d", entryId];

  NSURL* url = [NSURL URLWithString:urlStr];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSError* requestError;
  NSURLResponse* response;
  
  //Make request
  NSData* requestData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
  
  //Parse request
  NSError* jsonError;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:& jsonError];
  
  Pin* pin = nil;
  pin = [Pin pinWithJSONEntry:json];
  
  //Return resulting type
  return pin;
}

-(BOOL) addPin:(Pin*) pin {
  
  int entryId = [pin entryId];
  int userId = [pin userId];
  NSString* location = [pin location];
  NSString* specLocation = [pin specificLocation];
  NSString* subject = [pin subject];
  NSString* description = [pin description];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  NSString* dateStr = [dateReader stringFromDate:[pin date]];
  NSString* addDateStr = [dateReader stringFromDate:[pin addDate]];
  
  //Build Variable string and Data
  NSString* postStr = [NSString stringWithFormat:@"entryId=%d&userId=%d&location=%@&specLocation=%@&description=%@&subject=%@&time=%@&DBAddTime=%@", entryId, userId, location, specLocation, description, subject, dateStr, addDateStr];
  
  NSData* postData = [postStr dataUsingEncoding:NSASCIIStringEncoding];
  NSString* postDataLen = [NSString stringWithFormat:@"%d", [postData length]];
  
  //Build request
  NSString* urlStr = @"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/pins/";
  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:postDataLen forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  [request setTimeoutInterval:30];
  
  //Send request
  NSError* error;
  NSURLResponse* response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if (error) {
    return NO;
  }
  
  return YES;
}

#pragma mark User helper methods

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
  NSString* uIdStr = [NSString stringWithFormat:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/%d", uId];
  NSURL* url = [NSURL URLWithString:uIdStr];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
  [urlRequest setHTTPMethod:@"GET"];
  
  NSError* requestError;
  NSURLResponse* response;
  
  //Make request
  NSData* requestData= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
  
  //Parse request
  NSError* jsonError;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:& jsonError];
  
  User* user = nil;
  NSDictionary* userElem = nil;
  if([json count] == 2) {
    userElem = json;
    user = [User userWithJSONEntry:userElem];
  }
  else {
    userElem = [((NSArray*)json) objectAtIndex:0];
    user = [User userWithJSONEntry:userElem];
  }
  
  //Return resulting type
  return user;
}

-(BOOL) createUserWithId:(int) uId withCurrentLocation:(NSString*) location {
  
  //Build Variable string and Data
  NSString* postStr = [NSString stringWithFormat:@"userId=%d&lastKnownLocation=%@", uId, location];
  NSData* postData = [postStr dataUsingEncoding:NSASCIIStringEncoding];
  NSString* postDataLen = [NSString stringWithFormat:@"%d", [postData length]];
  
  //Build request
  NSString* urlStr = @"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/";
  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:postDataLen forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  [request setTimeoutInterval:30];
  
  //Send request
  NSError* error;
  NSURLResponse* response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if (error) {
    return NO;
  }
  
  return YES;
}

-(BOOL) updateCurrentPositionWithLocation:(NSString*) location {
  int uId = [Utilities getUserId];
  return [self updateUserLocationWithId:uId withLocation:location];
}

-(BOOL) updateUserLocationWithId:(int) uId withLocation: (NSString*) location {
  
  //Build Variable string and Data
  NSString* postStr = [NSString stringWithFormat:@"lastKnownLocation=%@", location];
  NSData* postData = [postStr dataUsingEncoding:NSASCIIStringEncoding];
  NSString* postDataLen = [NSString stringWithFormat:@"%d", [postData length]];
  
  //Build request
  NSString* urlStr = [NSString stringWithFormat:@"http://m.cip.gatech.edu/developer/notfound/api/GTWAT/users/%d", uId] ;

  NSURL* url = [NSURL URLWithString:urlStr];
  
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"PUT" forHTTPHeaderField:@"X-HTTP-Method-Override"];
  [request setValue:postDataLen forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  [request setTimeoutInterval:30];
  
  //Send request
  NSError* error;
  NSURLResponse* response;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if (error) {
    return NO;
  } 
  
  return YES;
}

@end
