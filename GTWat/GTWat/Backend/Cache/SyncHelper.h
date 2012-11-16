//
//  SyncHelper.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"

@interface SyncHelper : NSObject {
  NSTimer* syncTimer;
  NSDate* lastSynced;
  
  Cache* cache;
}

-(void) sync:(NSTimer*) timer;

@end
