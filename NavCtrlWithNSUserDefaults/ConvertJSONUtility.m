//
//  ConvertUtility.m
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "ConvertJSONUtility.h"

@implementation ConvertJSONUtility

//Convert Dictionary to JSON
+(NSData*) convertDictToJSON:(NSDictionary*)dict {
    
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"convertDictToJSON %@", error.localizedDescription);
    }
    
    
    return data;
}


//Convert JSON to Dictionary
+(NSDictionary*) convertJSONToDict:(NSData*)data{
    
    NSError* error = nil;
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSLog(@"convertJSONToDict %@", error.localizedDescription);
    }
    
    return result;
}



@end
