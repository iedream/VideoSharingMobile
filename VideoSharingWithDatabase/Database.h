//
//  Database.h
//  VideoSharingWithDatabase
//
//  Created by Catherine Zhao on 2016-04-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject
-(NSString *)uploadPlist:(NSDictionary*)dict name:(NSString*)name;
-(NSDictionary*)downloadPlist:(NSString*)name;
-(void)hi;

@end
