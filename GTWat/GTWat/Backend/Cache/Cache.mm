//
//  Cache.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Cache.h"
#import "/usr/include/sqlite3.h"

#import "User.h"
#import "Comment.h"
#import "Pin.h"

@implementation Cache

+(Cache*) getCacheInst {
  
  if(cacheInst == nil) {
    NSString* dbPath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];
    NSLog(@"Db Path: %@", dbPath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"cache.db"];
    
    cacheInst = [[Cache alloc] initWithDatabase:path];
  }
  
  return cacheInst;
}

-(id) initWithDatabase:(NSString*) dbPath {
  self = [super init];
  [self createEditableCopyOfDatabaseIfNeeded];
  
  //Interesting.... Prob not the same cache.db
  //that is in the project file and git. :O
  const char* dbpath = [dbPath UTF8String];
  NSLog(@"DB Path: %s", dbpath);
  
  
  
  int rc = sqlite3_open_v2(dbpath, &dbInst, SQLITE_OPEN_READWRITE, NULL);
//  int rc = sqlite3_open(dbpath, &dbInst);
  if(rc) {
    NSLog(@"Error");
  }
  
  return self;
}

-(void) createEditableCopyOfDatabaseIfNeeded {
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSError* fError;
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentDirectory = [paths objectAtIndex:0];
  NSString* writablePath = [documentDirectory stringByAppendingPathComponent:@"cache.db"];
  
  BOOL success = [fileManager fileExistsAtPath:writablePath];
  
  if(success) {
    return;
  }
  
  NSString* defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cache.db"];
  success = [fileManager copyItemAtPath:defaultPath toPath:writablePath error:&fError];
  if(!success) {
    NSAssert1(0, @"Failed to create writable database with message %@", [fError localizedDescription]);
  }
}

#pragma mark User Database Code

-(BOOL) writeUsersToDB:(NSDictionary*) userDict {
  
  NSArray* users = [userDict allValues];
  
  for(int i = 0; i < [users count]; i++) {
    User* user = [users objectAtIndex:i];
    [self writeUserToDB:user];
  }
  
  return NO;
}

-(BOOL) writeUserToDB:(User*) user {
  
  BOOL success = YES;
  
  int userid = [user userId];
  NSString* userLoc = [user lastKnownLocation];
  
  NSString* queryString = [NSString stringWithFormat:@"INSERT INTO users VALUES(%d, '%@');", userid, userLoc];
  
  // Execute SQL
  NSLog(@"Inserting a value into User table");
  char* error;
  const char *sqlInsert = [queryString UTF8String];
  int rc = sqlite3_exec(dbInst, sqlInsert, NULL, NULL, &error);
  if (rc)
  {
    NSLog(@"Error executing SQLite3 statement: %s", sqlite3_errmsg(dbInst));
    sqlite3_free(error);
    success = NO;
  }
  else
  {
    success = YES;
  }
  
  return success;
}

-(BOOL) readUsersFromDB:(NSMutableDictionary**) users {
  *users = [[NSMutableDictionary alloc]init];
  
  const char* selectQuery = "select * from users;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error reading User table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  else {
    for(int i = 1; i <= rows; i++) {
      int rowInd = (i*cols);
      
      char* uIdStr = results[rowInd];
      int uid = 0;
      if(uIdStr != NULL) {
        uid = atoi(results[rowInd]);
      }
      
      char* lastLocCharPtr = results[rowInd+1];
      NSString* lastLoc = @"";
      if(lastLocCharPtr != NULL) {
        lastLoc = [NSString stringWithUTF8String:lastLocCharPtr];
      }
      
      User* newUser = [[User alloc] initWithUserId:uid withLastLoc:lastLoc];
      [*users setObject:newUser forKey:[NSNumber numberWithInt:uid]];
    }
  }
  NSLog(@"Count: %d", [*users count]);
  sqlite3_free_table(results);
  return YES;
}

-(BOOL) clearUsersFromDB {
  
  const char* selectQuery = "delete from users;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error clearing User table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  
  return YES;
}

#pragma mark Comments

-(BOOL) writeCommentsToDB:(NSDictionary*) commentDict {
  
  NSArray* comments = [commentDict allValues];
  
  for(int i = 0; i < [comments count]; i++) {
    Comment* comment = [comments objectAtIndex:i];
    [self writeCommentToDB:comment];
  }
  
  return NO;
}

-(BOOL) writeCommentToDB:(Comment*) comment {
  
  BOOL success = YES;
  
  int commentid = [comment commentId];
  int entryid = [comment entryId];
  int uid = [comment userId];
  NSString* text = [comment text];
  NSDate* date = [comment date];
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString* dateStr = [dateReader stringFromDate:date];
  
  NSString* queryString = [NSString stringWithFormat:@"INSERT INTO comments VALUES(%d, %d, '%@', '%@', %d);", commentid, entryid, text, dateStr, uid];
  
  // Execute SQL
  char* error;
  const char *sqlInsert = [queryString UTF8String];
  int rc = sqlite3_exec(dbInst, sqlInsert, NULL, NULL, &error);
  if (rc)
  {
    NSLog(@"Error executing SQLite3 statement: %s", sqlite3_errmsg(dbInst));
    sqlite3_free(error);
    success = NO;
  }
  else
  {
    NSLog(@"Inserted a user into Comments.");
    success = YES;
  }
  
  return success;
}

-(BOOL) readCommentsFromDB:(NSMutableDictionary**) comments {
  *comments = [[NSMutableDictionary alloc]init];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  const char* selectQuery = "select * from comments;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error reading User table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  else {

    for(int i = 1; i <= rows; i++) {
      int rowInd = (i*cols);
      
      char* cIdStr = results[rowInd];
      int cid = 0;
      if(cIdStr != NULL) {
        cid = atoi(cIdStr);
      }
      
      char* eIdStr = results[rowInd+1];
      int eid = 0;
      if(eIdStr != NULL) {
        eid = atoi(eIdStr);
      }
      
      char* text = results[rowInd+2];
      NSString* nsText = @"";
      if(text != NULL) {
        nsText = [NSString stringWithUTF8String:text];
      }
      
      char* dateStr = results[rowInd+3];
      NSDate* date = nil;
      if(dateStr != NULL) {
        NSString* dateNSStr = [NSString stringWithUTF8String:dateStr];
        date = [dateReader dateFromString:dateNSStr];
      }
      
      char* uIdStr = results[rowInd+4];
      int uid = 0;
      if(uIdStr != NULL) {
        uid = atoi(uIdStr);
      }
      
      Comment* newComment = [[Comment alloc] initWithCommentId:cid withEntryId:eid withUserId:uid withDate:date withText:nsText];
      [*comments setObject:newComment forKey:[NSNumber numberWithInt:cid]];
    }
  }
  sqlite3_free_table(results);
  return YES;
}

-(BOOL) clearCommentsFromDB {
  const char* selectQuery = "delete from comments;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error clearing User table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  
  return YES;
}

#pragma mark Pins DB code

-(BOOL) writePinssToDB:(NSDictionary*) pinDict {
  NSArray* pins = [pinDict allValues];
  
  for(int i = 0; i < [pins count]; i++) {
    Pin* pin = [pins objectAtIndex:i];
    [self writePinToDB:pin];
  }
  
  return NO;
}

-(BOOL) writePinToDB:(Pin*) pin {
  BOOL success = YES;
  
  int entryid = [pin entryId];
  int uid = [pin userId];
  NSString* location = [pin location];
  NSString* subject = [pin subject];
  NSString* specLoc = [pin specificLocation];
  NSDate* time = [pin date];
  NSString* description = [pin description];
  NSDate* addDate = [pin addDate];
  int pinType = [pin pinType];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  NSString* dateStr = [dateReader stringFromDate:time];
  NSString* addDateStr = [dateReader stringFromDate:addDate];
  
  NSString* queryString = [NSString stringWithFormat:@"INSERT INTO pins VALUES(%d, %d, '%@', '%@', '%@', '%@', '%@', '%@', %d);", entryid, uid, location, subject, specLoc, dateStr, description, addDateStr, pinType];
  
  // Execute SQL
  char* error;
  const char *sqlInsert = [queryString UTF8String];
  int rc = sqlite3_exec(dbInst, sqlInsert, NULL, NULL, &error);
  if (rc)
  {
    NSLog(@"Error executing SQLite3 statement: %s", sqlite3_errmsg(dbInst));
    sqlite3_free(error);
    success = NO;
  }
  else
  {
    success = YES;
  }
  
  return success;
}

-(BOOL) readPinsFromDB:(NSMutableDictionary**) pins {
  *pins = [[NSMutableDictionary alloc]init];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  const char* selectQuery = "select * from pins;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error reading pin table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  else {
    
    for(int i = 1; i <= rows; i++) {
      int rowInd = (i*cols);
      
      char* eIdStr = results[rowInd];
      int eid = 0;
      if(eIdStr != NULL) {
        eid = atoi(eIdStr);
      }
      
      char* uIdStr = results[rowInd+1];
      int uid = 0;
      if(uIdStr != NULL) {
        uid = atoi(uIdStr);
      }
      
      char* location = results[rowInd+2];
      NSString* nsLocation = @"";
      if(location != NULL) {
        nsLocation = [NSString stringWithUTF8String:location];
      }
      
      char* subject = results[rowInd+3];
      NSString* nsSubject = @"";
      if(subject != NULL) {
        nsSubject = [NSString stringWithUTF8String:subject];
      }
      
      char* specLoc = results[rowInd+4];
      NSString* nsSpecLoc = @"";
      if(specLoc != NULL) {
        nsSpecLoc = [NSString stringWithUTF8String:specLoc];
      }
      
      char* dateStr = results[rowInd+5];
      NSDate* date = nil;
      if(dateStr != NULL) {
        NSString* dateNSStr = [NSString stringWithUTF8String:dateStr];
        date = [dateReader dateFromString:dateNSStr];
      }
      
      char* description = results[rowInd+6];
      NSString* nsDescription = @"";
      if(description != NULL) {
        nsDescription = [NSString stringWithUTF8String:description];
      }
      
      char* addDateStr = results[rowInd+7];
      NSDate* addDate = nil;
      if(addDateStr != NULL) {
        NSString* dateNSStr = [NSString stringWithUTF8String:addDateStr];
        addDate = [dateReader dateFromString:dateNSStr];
      }
      
      char* pinTypeStr = results[rowInd+8];
      int pinType = 0;
      if(pinTypeStr != NULL) {
        pinType = atoi(pinTypeStr);
      }
      
      Pin* newPin = [[Pin alloc] initWithEntryId:eid withUserId:uid withSubject:nsSubject withDescription:nsDescription withLocation:nsLocation withSpecLocation:nsSpecLoc withDate:date withAddDate:addDate];
      [newPin setPinType:pinType];
      [*pins setObject:newPin forKey:[NSNumber numberWithInt:eid]];
    }
  }
  sqlite3_free_table(results);
  return YES;
}

-(BOOL) clearPinsFromDB {
  const char* selectQuery = "delete from pins;";
  
  char** results = NULL;
  char* error;
  
  int rows, cols;
  int rc = sqlite3_get_table(dbInst, selectQuery, &results, &rows, &cols, &error);
  
  if(rc) {
    NSLog(@"Error clearing User table: %s", error );
    sqlite3_free(error);
    return NO;
  }
  
  return YES;
}

@end
