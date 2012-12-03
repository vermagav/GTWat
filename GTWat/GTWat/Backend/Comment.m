//
//  Comment.m
//  GTWat
//
//  Created by Kevin Hampton on 11/19/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize commentId = _commentId, entryId = _entryId, userId = _userId;
@synthesize text = _text;
@synthesize date = _date;

-(id) initWithCommentId:(int) commentId withEntryId:(int) entryId withUserId:(int) userId withDate:(NSDate*) date withText:(NSString*) text {
  self = [super init];
  
  _commentId = commentId;
  _entryId = entryId;
  _userId = userId;
  _date = date;
  _text = text;
  
  [_text retain];
  [_date retain];
  
  return self;
}

+(id) commentWithJSONEntry:(NSDictionary*) jsonElement {
  Comment* comment = nil;
  
  int commentId = [[jsonElement objectForKey:@"commentId"] intValue];
  int entryId = [[jsonElement objectForKey:@"entryId"] intValue];
  int userId = [[jsonElement objectForKey:@"userId"] intValue];
  NSString* text = [jsonElement objectForKey:@"text"];
  NSString* dateStr = [jsonElement objectForKey:@"time"];
  
  NSDateFormatter* dateReader = [[NSDateFormatter alloc] init];
  [dateReader setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSDate* date = [dateReader dateFromString:dateStr];
  
  comment = [[Comment alloc] initWithCommentId:commentId withEntryId:entryId withUserId:userId withDate:date withText:text];
  
  return comment;
}

@end
