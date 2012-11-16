//
//  Utilities.m
//  GTWat
//
//  Created by Kevin Hampton on 11/16/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Utilities.h"

static int userId;

@implementation Utilities

+ (int) getUserId {
  return userId;
}

+ (int) loadUserId {
  NSString* docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString* idFile = [docsPath stringByAppendingPathComponent:@"id.txt"];
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:idFile];
  
  NSError* error;
  
  if(fileExists) {
    NSString* idStr = [NSString stringWithContentsOfFile:idFile encoding:NSUTF8StringEncoding error:&error];
    userId = [idStr intValue];
  }
  else {
    userId = abs(rand());
    NSString* idStr = [NSString stringWithFormat:@"%d", userId];
    BOOL writeSucc = [idStr writeToFile:idFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(!writeSucc) {
    }
  }
  
  return userId;
}

@end
