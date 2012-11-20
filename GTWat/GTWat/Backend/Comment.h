//
//  Comment.h
//  GTWat
//
//  Created by Kevin Hampton on 11/19/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject {
  int _commentId;
  int _entryId;
  int _userId;
  
  NSString* _text;
  
  NSDate* _date;
}

@property int commentId;
@property int entryId;
@property int userId;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSDate* date;

-(id) initWithCommentId:(int) commentId withEntryId:(int) entryId withUserId:(int) userId withDate:(NSDate*) date withText:(NSString*) text;
+(id) commentWithJSONEntry:(NSDictionary*) jsonElement;
@end
