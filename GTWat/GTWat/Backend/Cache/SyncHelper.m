//
//  SyncHelper.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "SyncHelper.h"

#define SYNCMINS 10

@implementation SyncHelper

- (id) init {
  self = [super init];
  
  NSString* dbPath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];
  
  cache = [[Cache alloc] initWithDatabase:dbPath];
  
  //syncTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sync:) userInfo:nil repeats:YES];
  //[self sync:nil];
  return self;
}

-(void) sync:(NSTimer*) timer {
  NSLog(@"Syncing");
  
  lastSynced = [NSDate date];
  
  [self performSelectorInBackground:@selector(syncCache) withObject:nil];
}

-(void) syncCache {
  NSLog(@"I am in the background. :O");
}

@end
