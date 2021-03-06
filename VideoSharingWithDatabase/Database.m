//
//  Database.m
//  VideoSharingWithDatabase
//
//  Created by Catherine Zhao on 2016-04-02.
//  Copyright © 2016 Catherine. All rights reserved.
//

#import "Database.h"

@implementation Database

#pragma mark - Route Method
-(void)uploadPlist:(NSDictionary*)dict name:(NSString*)name {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = [self dictToJson:dict group:nil password:nil];
    // calculate body string length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/data/%@", encodedName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [self uploading:[request copy]];
}

-(void)uploadPlist:(NSDictionary *)dict name:(NSString *)name group:(NSString*)group password:(NSString*)password {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *encodedGroup = [group stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = [self dictToJson:dict group:nil password:password];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/group/%@/data/%@", encodedGroup, encodedName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [self uploading:[request copy]];
}

-(void)downloadPlist:(NSString*)name {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/data/%@", encodedName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"GET"];
    [self downloading:[request copy]];
}

-(void)downloadPlist:(NSString *)name group:(NSString*)group password:(NSString*)password {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *encodedGroup = [group stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/group/%@/data/%@?password=%@", encodedGroup, encodedName, password];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"GET"];
    [self downloading:[request copy]];
}

-(void)createGroup:(NSString*)group password:(NSString*)password {
    NSData *data = [self dictToJson:nil group:group password:password];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://video-sharing-database.herokuapp.com/group"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [self creating:[request copy]];
}

-(void)delete:(NSString *)name {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/data/%@", encodedName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [self deleting:[request copy]];
}

-(void)delete:(NSString *)name group:(NSString *)group password:(NSString*)password {
    NSString *encodedName = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *encodedGroup = [group stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data = [self dictToJson:nil group:nil password:password];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
    NSString *url = [NSString stringWithFormat:@"https://video-sharing-database.herokuapp.com/group/%@/data/%@", encodedGroup, encodedName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [self deleting:[request copy]];
}

#pragma mark - Main Method
-(void)uploading:(NSURLRequest*)request {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if ([httpResponse statusCode] == 200){
                
                [result setValue:[json valueForKey:@"data"] forKey:@"data"];
            }else {
                [result setValue:[json valueForKey:@"error"] forKey:@"error"];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlistUploaded" object:nil userInfo:result];
    }];
    [task resume];
}

-(void)downloading:(NSURLRequest*)request {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if ([httpResponse statusCode] == 200){
                NSDictionary *videoIds = [self jsonToDict:json];
                [result setValue:videoIds forKey:@"data"];
            }else {
                [result setValue:[json valueForKey:@"error"] forKey:@"error"];
            }
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlistDownloaded" object:nil userInfo:result];
    }];
    [task resume];
}

-(void)creating:(NSURLRequest*)request {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if ([httpResponse statusCode] == 200){
                
                [result setValue:[json valueForKey:@"data"] forKey:@"data"];
            }else {
                [result setValue:[json valueForKey:@"error"] forKey:@"error"];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GroupCreated" object:nil userInfo:result];
    }];
    [task resume];
}

-(void)deleting:(NSURLRequest*)request {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            [result setValue:[error localizedDescription] forKey:@"error"];
        }else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if ([httpResponse statusCode] == 200){
                
                [result setValue:[json valueForKey:@"data"] forKey:@"data"];
            }else {
                [result setValue:[json valueForKey:@"error"] forKey:@"error"];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlaylistDeleted" object:nil userInfo:result];
    }];
    [task resume];
}

#pragma mark - Helper Method
-(NSData*)dictToJson:(NSDictionary*)dict group:(NSString*)group password:(NSString*)password {
    // convert dict into json if neccessary
    NSString * stringDict;
    if (dict) {
        NSError *err;
        // conver dict to json
         NSData * jsonDict = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        // conver json to string
         stringDict = [[NSString alloc] initWithData:jsonDict encoding:NSUTF8StringEncoding];
        
        NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
        NSCharacterSet *customEncodingSet = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        stringDict = [stringDict stringByAddingPercentEncodingWithAllowedCharacters:customEncodingSet];
    }
    // create body string
    NSString *dataString;
    if(password && dict) {
        dataString = [NSString stringWithFormat:@"data=%@&password=%@", stringDict, password];
    }else if(group && password) {
        dataString = [NSString stringWithFormat:@"groupId=%@&password=%@",group, password];
    }else if(password) {
        dataString = [NSString stringWithFormat:@"password=%@",password];
    }else if(dict){
        dataString = [NSString stringWithFormat:@"data=%@",stringDict];
    }
    
    // encode body string
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return data;
}

-(NSDictionary*)jsonToDict:(NSDictionary*)json {
    NSString *jsonString = [json valueForKey:@"data"];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *videoIds = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return  videoIds;
}

@end
