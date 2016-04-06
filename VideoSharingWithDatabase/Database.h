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
-(void)uploadPlist:(NSDictionary *)dict name:(NSString *)name group:(NSString*)group password:(NSString*)password;
-(void)downloadPlist:(NSString*)name;
-(void)downloadPlist:(NSString *)name group:(NSString*)group password:(NSString*)password;
-(void)createGroup:(NSString*)group password:(NSString*)password;

@end
