//
//  Cache.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface Cache : NSObject {
  sqlite3* dbInst;
  
}

-(id) initWithDatabase:(NSString*) dbPath;

@end
