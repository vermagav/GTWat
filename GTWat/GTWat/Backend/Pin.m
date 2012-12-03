//
//  Pin.m
//  GTWat
//
//  Created by Kevin Hampton on 11/19/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Pin.h"
#import "Comment.h"

@implementation Pin

@synthesize entryId = _entryId, userId = _userId;
@synthesize pinType = _pinType;
@synthesize subject = _subject, description = _description;
@synthesize location = _location, specificLocation = _specLocation;
@synthesize date = _date, addDate = _addDate;
@synthesize comments = _comments;
@synthesize annotationView = _annotationView;

-(id) initWithEntryId:(int) entryId withUserId:(int) userId withSubject:(NSString*) subject withDescription:(NSString*) description withLocation:(NSString*) location withSpecLocation:(NSString*) specLocation withDate:(NSDate*) date withAddDate:(NSDate*) addDate {
  self = [super init];
  
  _entryId = entryId;
  _userId = userId;
  _subject = subject;
  [_subject retain];
  _description = description;
  [_description retain];
  _location = location;
  [_location retain];
  _specLocation = specLocation;
  [_specLocation retain];
  _date = date;
  [_date retain];
  _addDate = addDate;
  
  NSArray *descParse = [description componentsSeparatedByString:@":"];
  int numElements = [descParse count];
  
  NSString* pinTypeStr = @"";
  if(numElements == 2) {
    _description = [descParse objectAtIndex:1];
    pinTypeStr = [descParse objectAtIndex:0];
    _pinType = [pinTypeStr intValue];
  }
  else {
    _pinType = -1;
  }
  
  return self;
}

-(id) initWithEntryId:(int) entryId withUserId:(int) userId withSubject:(NSString*) subject withDescription:(NSString*) description withLocation:(NSString*) location withSpecLocation:(NSString*) specLocation withDate:(NSDate*) date withAddDate:(NSDate*) addDate withPinType:(int)pinType {
  self = [self initWithEntryId:entryId withUserId:userId withSubject:subject withDescription:description withLocation:location withSpecLocation:specLocation withDate:date withAddDate:addDate];
  _pinType = pinType;
  return self;
}

-(id) withAnnotationView: (MKPointAnnotation*) annotationView initWithEntryId:(int) entryId withUserId:(int) userId withSubject:(NSString*) subject withDescription:(NSString*) description withLocation:(NSString*) location withSpecLocation:(NSString*) specLocation withDate:(NSDate*) date withAddDate:(NSDate*) addDate {
  self = [self initWithEntryId:entryId withUserId:userId withSubject:subject withDescription:description withLocation:location withSpecLocation:specLocation withDate:date withAddDate:addDate];
  _annotationView = annotationView;
  
  return self;
}

-(void) addComment:(Comment*) comment {
  [_comments addObject:comment];
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
