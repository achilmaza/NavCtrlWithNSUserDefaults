//
//  CompanyDAO.h
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "Company.h"
#import "RestAPI.h"

@protocol CompanyDAOProtocol <NSObject>

-(void)reloadData;

@end


@interface CompanyDAO : NSObject <RestAPIDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, assign) id<CompanyDAOProtocol> delegate;

+(instancetype)sharedDAOInstance;
-(NSInteger)getCompanyCount;
-(void)addCompany:(Company*)companyVal atIndex:(NSUInteger)indexVal;
-(void)deleteCompanyAtIndex:(NSUInteger)indexVal;
-(Company*)getCompanyAtIndex:(NSUInteger)indexVal;
-(void)moveCompany:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal;
-(NSArray*)getCompanyProducts:(NSUInteger)indexVal;
-(void)deleteCompanyProduct:(Company*)companyVal atIndex:(NSUInteger)indexVal;
-(void)moveCompanyProduct:(Company*)company fromIndex:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal;

@end
