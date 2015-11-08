//
//  Company.h
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

@class Product;

@interface Company : NSObject <NSCopying, NSCoding>

@property (nonatomic, assign) int cid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* logo;
@property (nonatomic, strong) NSString* askPrice;
@property (nonatomic, strong) NSMutableArray * products;

- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andProducts:(NSMutableArray*)productsVal andId:(int)idVal NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andId:(int)idVal;
- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal;
-(NSInteger)getProductCount;
-(Product*)getProductAtIndex:(NSUInteger)index;
-(void)addProductWith:(Product*)productVal;
-(void)addProductWith:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal;
-(void)addProductWith:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal andId:(int)idVal;
-(void)deleteProductAtIndex:(NSUInteger)index;
-(void)moveProduct:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal;

@end
