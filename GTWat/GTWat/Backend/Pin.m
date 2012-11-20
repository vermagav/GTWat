//
//  Pin.m
//  GTWat
//
//  Created by Kevin Hampton on 11/19/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@synthesize entryId = _entryId, userId = _userId;
@synthesize subject = _subject, description = _description;
@synthesize location = _location, specificLocation = _specLocation;
@synthesize date = _date, addDate = _addDate;

-(id) initWithEntryId:(int) entryId withUserId:(int) userId withSubject:(NSString*) subject withDescription:(NSString*) description withLocation:(NSString*) location withSpecLocation:(NSString*) specLocation withDate:(NSDate*) date withAddDate:(NSDate*) addDate {
  self = [super init];
  
  _entryId = entryId;
  _userId = userId;
  _subject = subject;
  _description = description;
  _location = location;
  _specLocation = specLocation;
  _date = date;
  _addDate = addDate;
  
  return self;
}

+(id) pinWithJSONEntry:(NSDictionary*) jsonElement {
  
  int entryId = [[jsonElement objectForKey:@"entryId"] intValue];
  int userId = [[jsonElement objectForKey:@"userId"] intValue];
  
  NSString* location = [jsonElement objectForKey:@"location"];
  NSString* specLocation = [jsonElement objectForKey:@"specLocation"];
  NSString* subject = [jsonElement objectForKey:@"subject"];
  NSString* description = [jsonElement objectForKey:@"description"];
  NSString* pinTime = [jsonElement objectForKey:@"time"];
  NSString* addTime = [jsonElement objectForKey:@"DBAddTime"];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSDate* pinDateTime = [dateReader dateFromString:pinTime];
  NSDate* addPinTime = [dateReader dateFromString:addTime];
  
  Pin* newPin = [[Pin alloc] initWithEntryId:entryId withUserId:userId withSubject:subject withDescription:description withLocation:location withSpecLocation:specLocation withDate:pinDateTime withAddDate:addPinTime];
  
  return newPin;
}

@end
