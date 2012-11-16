//
//  Cache.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Cache.h"
#import "/usr/include/sqlite3.h"

@implementation Cache

-(id) initWithDatabase:(NSString*) dbPath {
  self = [super init];
  
  const char* dbpath = [dbPath UTF8String];
  int rc = sqlite3_open(dbpath, &dbInst);
  if(rc) {
    NSLog(@"Error");
  }
  
  return self;
}

@end
