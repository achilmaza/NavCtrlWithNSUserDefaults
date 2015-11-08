//
//  ConvertUtility.h
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertJSONUtility : NSObject

+(NSData*) convertDictToJSON:(NSDictionary*)dict;
+(NSDictionary*) convertJSONToDict:(NSData*)data;


@end
