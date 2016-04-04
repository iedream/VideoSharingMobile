//
//  Database.h
//  VideoSharingWithDatabase
//
//  Created by Catherine Zhao on 2016-04-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Database : NSObject
-(void)uploadPlist:(NSDictionary*)dict name:(NSString*)name;
-(void)downloadPlist:(NSString*)name;
-(void)hi;

@end
