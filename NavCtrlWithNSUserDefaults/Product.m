//
//  Product.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "Product.h"

@interface Product ()


@end

@implementation Product

-(instancetype)init{
    
    return [self initWithName:@"" andLogo:@"" andUrl:@"" andId:0];
}

-(instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal {
    
    return [self initWithName:nameVal andLogo:logoVal andUrl:urlVal andId:0];
}

- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal andId:(int)idVal{
    self = [super init];
    if (self) {
    
        self.name = [[nameVal copy] autorelease];
        self.logo = [[logoVal copy] autorelease];
        self.url  = [[urlVal copy] autorelease];
        self.pid  = idVal;
    }
    return self;
}


-(NSString*)description{
    
    return [NSString stringWithFormat:@"[%@][%@][%@][%i]", self.name, self.logo, self.url, self.pid];
}

-(id)copyWithZone:(NSZone *)zone {
    
    return [[Product allocWithZone:zone]initWithName:self.name andLogo:self.logo andUrl:self.url andId:self.pid];
}

-(id)mutableCopyWithZone:(NSZone*)zone{
    
    return [[Product allocWithZone:zone]initWithName:self.name andLogo:self.logo andUrl:self.url andId:self.pid];

}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeObject:[self logo] forKey:@"logo"];
    [encoder encodeObject:[self url] forKey:@"url"];
    [encoder encodeObject:[NSString stringWithFormat:@"%i",[self pid]] forKey:@"pid"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    return [self initWithName:[decoder decodeObjectForKey:@"name"]
                      andLogo:[decoder decodeObjectForKey:@"logo"]
                       andUrl:[decoder decodeObjectForKey:@"url"]
                        andId:[[decoder decodeObjectForKey:@"pid"] intValue]];
     
}

- (void)dealloc {
      
    [_name release];
    [_logo release];
    [_url release];
    [super dealloc];
}


@end
