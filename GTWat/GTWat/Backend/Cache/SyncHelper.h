//
//  SyncHelper.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"

@class User;
@class Pin;
@class Comment;

@interface SyncHelper : NSObject {
  NSTimer* syncTimer;
  NSDate* lastSynced;
  
  NSDictionary* cachedUsers;
  NSDictionary* cachedComments;
  NSDictionary* cachedPins;
  
  BOOL _isWritingToCache;
  Cache* cache;
}

-(void) sync:(NSTimer*) timer;
-(BOOL) isWritingToCache;

-(NSDictionary*) requestComments;
-(Comment*) requestCommentWithCommentId:(int) commentId;
-(BOOL) addComment:(Comment*) comment;

//Pins
-(NSDictionary*) requestPins;
-(Pin*) requestPinWithEntryId:(int) entryId;
-(BOOL) addPin:(Pin*) pin;

//Users
//Creating user
-(BOOL) createUserWithId:(int) uId withCurrentLocation:(NSString*) location;

//Requesting Users
-(User*) requestUserWithId:(int) uId;
-(NSDictionary*) requestUsers;

//Updating user location
-(BOOL) updateCurrentPositionWithLocation:(NSString*) location;
-(BOOL) updateUserLocationWithId:(int) uId withLocation: (NSString*) location;

@end
