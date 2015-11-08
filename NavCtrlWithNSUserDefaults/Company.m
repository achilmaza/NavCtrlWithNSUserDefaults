//
//  Company.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "Company.h"
#import "Product.h"

@interface Company ()

@end


@implementation Company

- (instancetype)init
{
    NSMutableArray* prodsVal = [[NSMutableArray alloc] init];
    NSString* nameVal = [[NSString alloc] init];
    NSString* logoVal = [[NSString alloc] init];
    
    self = [self initWithName:nameVal andLogo:logoVal andProducts:prodsVal andId:0];
    
    [prodsVal release];
    [nameVal release];
    [logoVal release];
    
    return self;
}

- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal {
    
    NSMutableArray* prodsVal = [[NSMutableArray alloc]init];
    
    self = [self initWithName:nameVal andLogo:logoVal andProducts:prodsVal andId:0];
    
    [prodsVal release];
    
    return self;
}


- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andId:(int)idVal{
    
    NSMutableArray* prodsVal = [[NSMutableArray alloc]init];
    
    self = [self initWithName:nameVal andLogo:logoVal andProducts:prodsVal andId:idVal];
    
    [prodsVal release];
    
    return self;
}


- (instancetype)initWithName:(NSString*)nameVal andLogo:(NSString*)logoVal andProducts:(NSMutableArray*)productsVal andId:(int)idVal{

    self = [super init];
    if (self) {
        
        self.cid  = idVal;
        self.name = [[nameVal copy] autorelease];
        self.logo = [[logoVal copy] autorelease];
        
        if([productsVal count] > 0){
            self.products = [[[NSMutableArray alloc] initWithArray:productsVal] autorelease];
        }
        else {
            self.products = [[[NSMutableArray alloc] init] autorelease];
        }
    }
    
    return self;
}

-(NSInteger)getProductCount{
    
    return [self.products count];
}

-(void)addProductWith:(Product*)productVal{
    
    [self.products addObject:productVal];
}

-(void)addProductWith:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal{
 
    Product* newProd = [[Product alloc] initWithName:nameVal andLogo:logoVal andUrl:urlVal andId:0];
    [self.products addObject:newProd];
    [newProd release];
}

-(void)addProductWith:(NSString*)nameVal andLogo:(NSString*)logoVal andUrl:(NSString*)urlVal andId:(int)idVal{
    
    Product* newProd = [[Product alloc] initWithName:nameVal andLogo:logoVal andUrl:urlVal andId:idVal];
    [self.products addObject:newProd];
    [newProd release];
}

-(void)deleteProductAtIndex:(NSUInteger)indexVal {
    
    [self.products removeObjectAtIndex:indexVal];
}

-(Product*)getProductAtIndex:(NSUInteger)indexVal {
    
    return [self.products objectAtIndex:indexVal];
}

-(void)moveProduct:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal{
    
    Product* selectedProduct = [self.products objectAtIndex:fromIndexVal];
    
    [self.products removeObjectAtIndex:fromIndexVal];
    [self.products insertObject:selectedProduct atIndex:toIndexVal];

}
 
-(NSString*)description{
    
   return [NSString stringWithFormat:@"[Company][%@] [Logo][%@] [Products][%@] [ID][%i]", self.name, self.logo, self.products, self.cid];
}

-(id)copyWithZone:(NSZone *)zone {
    
    Company* company = [[Company allocWithZone:zone]initWithName:self.name andLogo:self.logo andProducts:self.products andId:self.cid];
    company.askPrice = self.askPrice;
    return company;
}

-(id)mutableCopyWithZone:(NSZone*)zone{
    
    Company* company = [[Company allocWithZone:zone]initWithName:self.name andLogo:self.logo andProducts:self.products andId:self.cid];
    company.askPrice = self.askPrice;
    return company;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeObject:[self logo] forKey:@"logo"];
    [encoder encodeObject:[self products] forKey:@"products"];
    [encoder encodeObject:[NSString stringWithFormat:@"%i",[self cid]]];
     
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [self initWithName:[decoder decodeObjectForKey:@"name"]
                      andLogo:[decoder decodeObjectForKey:@"logo"]
                  andProducts:[decoder decodeObjectForKey:@"products"]
                        andId:[[decoder decodeObjectForKey:@"cid"] intValue]];
  
}

- (void)dealloc {

    [_name release];
    [_logo release];
    [_askPrice release];
    [self.products removeAllObjects];
    [_products release];
    
    [super dealloc];
}

@end
