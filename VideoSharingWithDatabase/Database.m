//
//  Database.m
//  VideoSharingWithDatabase
//
//  Created by Catherine Zhao on 2016-04-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

#import "Database.h"

@implementation Database

-(NSString *)uploadPlist:(NSDictionary*)dict name:(NSString*)name {
    NSError *err;
    // conver dict to json
    NSData * jsonDict = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
    // conver json to string
    NSString * stringDict = [[NSString alloc] initWithData:jsonDict encoding:NSUTF8StringEncoding];
    // create body string
    NSString *dataString = [NSString stringWithFormat:@"name=%@&data=%@",name, stringDict];
    // encode body string
    NSData *data = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    // calculate body string length
    NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
    
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://video-sharing-database.herokuapp.com/post_data"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *err;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([httpResponse statusCode] == 200){
            
            [result setValue:[json valueForKey:@"data"] forKey:@"data"];
        }else {
            [result setValue:[json valueForKey:@"error"] forKey:@"error"];
        }
    }];
    [task resume];
    
    return [NSString stringWithFormat:@"%@", result.allValues.firstObject];
}

-(void)hi {
    NSLog(@"hi");
}

-(NSDictionary*)downloadPlist:(NSString*)name {
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/get_data?name=%@", name];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"GET"];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *err;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([httpResponse statusCode] == 200){
            NSDictionary *data = [json valueForKey:@"data"];
            // Parse Data
            NSString *jsonString = [[data valueForKey:@"data"] firstObject];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *videoIds = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            // Grab name
            NSString *name = [[data valueForKey:@"title"] firstObject];
            [result setValue:videoIds forKey:name];
        }else {
            [result setValue:[json valueForKey:@"error"] forKey:@"error"];
        }
    }];
    [task resume];
    
    
    return result;
}

@end
