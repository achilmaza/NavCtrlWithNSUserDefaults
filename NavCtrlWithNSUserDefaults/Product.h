//
//  Product.h
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//


@interface Product : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) int pid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* logo;
@property (nonatomic, strong) NSString* url;

- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal andId:(int)idVal NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal;

@end
