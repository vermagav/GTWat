//
//  Pin.h
//  GTWat
//
//  Created by Kevin Hampton on 11/19/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment;

@interface Pin : NSObject {
  int _userId;
  int _entryId;
  NSString* _location;
  NSString* _subject;
  NSString* _description;
  NSString* _specLocation;
  NSString* _strDate;
  NSDate* _date;
  NSDate* _addDate;
  
  int _pinType;
  
  NSMutableArray* _comments;
}

@property int userId;
@property int entryId;
@property int pinType;

@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSString* subject;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* specificLocation;

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSDate* addDate;

@property (nonatomic, retain) NSMutableArray* comments;

-(id) initWithEntryId:(int) entryId withUserId:(int) userId withSubject:(NSString*) subject withDescription:(NSString*) description withLocation:(NSString*) location withSpecLocation:(NSString*) specLocation withDate:(NSDate*) date withAddDate:(NSDate*) addDate;

-(void) addComment:(Comment*) comment;

+(id) pinWithJSONEntry:(NSDictionary*) jsonElement;

@end
