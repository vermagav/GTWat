//
//  Cache.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@class User;
@class Comment;
@class Pin;

@interface Cache : NSObject {
  sqlite3* dbInst;
  
}

-(id) initWithDatabase:(NSString*) dbPath;

-(BOOL) writeUsersToDB:(NSDictionary*) users;
-(BOOL) writeUserToDB:(User*) user;
-(BOOL) readUsersFromDB:(NSMutableDictionary**) users;
-(BOOL) clearUsersFromDB;

-(BOOL) writeCommentsToDB:(NSDictionary*) commentDict;
-(BOOL) writeCommentToDB:(Comment*) comment;
-(BOOL) readCommentsFromDB:(NSMutableDictionary**) comments;
-(BOOL) clearCommentsFromDB;

-(BOOL) writePinssToDB:(NSDictionary*) pinDict;
-(BOOL) writePinToDB:(Pin*) pin;
-(BOOL) readPinsFromDB:(NSMutableDictionary**) pins;
-(BOOL) clearPinsFromDB;

+(Cache*) getCacheInst;

@end

static Cache* cacheInst;