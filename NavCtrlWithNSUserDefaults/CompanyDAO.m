//
//  CompanyDAO.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "CompanyDAO.h"
#import "Company.h"
#import "Product.h"
#import "RestAPI.h"

static NSString * const userDefaultsKey = @"CompanyAndProductList";

@interface CompanyDAO ()

@property (nonatomic, strong) NSMutableArray* companyAndProductList;
@property (nonatomic, strong) RestAPI* asyncAPI;
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) NSURLSession * session;

-(void)removeUserDefaults;
-(void)loadCompanyListDefaults;
-(void)loadCompanyListFromUserDefaults;
-(void)saveCompanyListToUserDefaults;


@end


@implementation CompanyDAO

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.asyncAPI = [[[RestAPI alloc] init] autorelease];
        [self loadCompanyListFromUserDefaults];
        
    }
    return self;
}

//singleton 
+ (instancetype)sharedDAOInstance {
    
    static id _sharedDAOInstance = nil;
    static dispatch_once_t onceToken;
    
    //GCD call - Grand Central Dispatch call
    dispatch_once(&onceToken, ^{
         NSLog(@"Instantiating instance of DAO \n");
        _sharedDAOInstance = [[self alloc] init];
    });
    
    return _sharedDAOInstance;
}

//lazy loading
-(NSMutableArray *)companyAndProductList{
    
    if(!_companyAndProductList){
        _companyAndProductList = [[NSMutableArray alloc]init];
    }
    
    return _companyAndProductList;
}

-(void)removeUserDefaults{
    
    // NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    // [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    //Remove key in NSUserDefaults
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:userDefaultsKey];
    
}


#pragma mark NSUserDefaults 

-(void)loadCompanyListFromUserDefaults{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:userDefaultsKey];
    
    if(encodedObject != nil){
        NSMutableArray* archiveData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        NSLog(@"archive data = %@ \n", archiveData);
        
        [self.companyAndProductList addObjectsFromArray:archiveData];
        //self.companyAndProductList = archiveData; //companyAndProductList will take ownership of archiveData
    }
    else {
        [self loadCompanyListDefaults];
    }

    [self httpSessionGetRequest];
    
}

//load defaults from json file if NSUserDefaults has not been loaded 
-(void)loadCompanyListDefaults{
    
    
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"companies"
                                                         ofType:@"json"];
    
    if(filePath == nil)
        return ;
    
    NSLog(@"filepath = %@ \n", filePath);
    
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    if (error != nil) {
        NSLog(@"Error: was not able to load messages.");
    }
    
    NSLog(@"data = %@ \n", data);
    
    NSArray * companyInfo = [data valueForKey:@"companies"];
    NSUInteger companyCount = [companyInfo count];
    
    for(int i=0; i<companyCount; i++){
        
        Company * company = [[Company alloc] initWithName:companyInfo[i][@"name"] andLogo:companyInfo[i][@"logo"]];
        
        NSArray* products = companyInfo[i][@"products"];
        NSUInteger prodCount = [products count];
        
        for(int j=0; j<prodCount; j++){
            
            Product* product = [[Product alloc] initWithName:products[j][@"name"] andLogo:products[j][@"logo"] andUrl: products[j][@"url"]];
            [company addProductWith:product];
            [product release];
        }
        
        [self addCompany:company];
        [company release];
        
    }
    
    [self saveCompanyListToUserDefaults];
}


-(void)saveCompanyListToUserDefaults {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"companyAndProducList = %@ \n", self.companyAndProductList);
    
    NSMutableArray * archiveData = [[NSMutableArray alloc] initWithArray:self.companyAndProductList];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:archiveData];
    [defaults setObject:encodedObject forKey:userDefaultsKey];
    [defaults synchronize];
    
    //release allocated NSMutableArray
    [archiveData release];

}

#pragma mark Company/Product
-(NSInteger)getCompanyCount{
    
    return [self.companyAndProductList count];
}


-(void)addCompany:(Company*)companyVal {
    
    [self.companyAndProductList addObject:companyVal];
}


-(void)addCompany:(Company*)companyVal atIndex:(NSUInteger)indexVal {
    
    [self.companyAndProductList insertObject:companyVal atIndex:indexVal];
}


-(void)deleteCompanyAtIndex:(NSUInteger)indexVal{
    
    //check for valid index
    if(indexVal < [self getCompanyCount]){
        
        //Delete from array
        [self.companyAndProductList removeObjectAtIndex:indexVal];
        [self saveCompanyListToUserDefaults];
    }
    
}

-(Company*)getCompanyAtIndex:(NSUInteger)indexVal{
    
    //check for valid index
    if(indexVal < [self getCompanyCount]){
        return [self.companyAndProductList objectAtIndex:indexVal];
    }
    else{
        return nil;
    }
}

-(void)moveCompany:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal{
    
    Company* selectedCompany = [[self.companyAndProductList objectAtIndex:fromIndexVal] mutableCopy];
    [self.companyAndProductList removeObjectAtIndex:fromIndexVal];
    [self.companyAndProductList insertObject:selectedCompany atIndex:toIndexVal];
    [selectedCompany release];
    [self saveCompanyListToUserDefaults];
}


-(NSArray*)getCompanyProducts:(NSUInteger)indexVal {
    
    if(indexVal < [self getCompanyCount]){
        Company* selectedCompany = [self.companyAndProductList objectAtIndex:indexVal];
        return [selectedCompany products];
    }
    else{
        return nil;
    }
}

-(void)deleteCompanyProduct:(Company*)companyVal atIndex:(NSUInteger)indexVal {
    
    if(companyVal){
        
        [companyVal deleteProductAtIndex:indexVal];
        
        if(indexVal < [companyVal getProductCount]){
            
            [self saveCompanyListToUserDefaults];
        }
    }
    
}

-(void)moveCompanyProduct:(Company*)company fromIndex:(NSUInteger)fromIndexVal toIndex:(NSUInteger)toIndexVal{
    
    [company moveProduct:fromIndexVal toIndex:toIndexVal];
    [self saveCompanyListToUserDefaults];
}


-(NSString*)description{
    
    return [NSString stringWithFormat:@"%@", self.companyAndProductList];
}


#pragma mark HTTP
//GET request
-(void)httpGetRequest{
    
    NSString* str = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+003550.KS+NOK+018260.KS&f=nabp";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:str];
    
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
//  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.asyncAPI.mDelegate = self;
    [self.asyncAPI httpRequest:request];
}


-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender{
    
    NSLog(@"CompanyDAO getReceivedData 1 = %@\n", data);
    
    if([data length]){
        
        NSString * myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n", myData);
        
        //Parse csv data
        NSArray * parsedRows = [myData componentsSeparatedByString:@"\n"];
        NSInteger rowCount = [parsedRows count];
        NSInteger companyCount = [self.companyAndProductList count];
        
        for(int i=0; i<rowCount && i<companyCount; i++){
            NSArray * parsedColumns = [parsedRows[i] componentsSeparatedByString:@","];
            if(parsedColumns != nil){
                
                //need to modify this if saving upon row reodering
                Company* selectedCompany = [self.companyAndProductList objectAtIndex:i];
                [selectedCompany setAskPrice:[NSString stringWithFormat:@"%@", parsedColumns[1]]];
                
            }
            
        }
        
        [myData release];
        
        //switch to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reloadData];
        });
        
    }
    
}


-(void)httpSessionGetRequest {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    
    //Create session
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    //Create url
    NSString* str = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+003550.KS+NOK+018260.KS&f=sabp";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:str];
    
    //Create data task
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
    
}

#pragma mark NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if(error){
        NSLog(@"URLSession:task:didCompleteWithError rc=%@\n", error.description);
    }
    else{
        
        if([self.receivedData length]){
            
            NSString * myData = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
            NSLog(@"%@\n", myData);
            
            //Parse csv data
            NSArray * parsedRows = [myData componentsSeparatedByString:@"\n"];
            NSInteger count = [parsedRows count];
            NSInteger companyCount = [self.companyAndProductList count];
            
            for(int i=0; i<count && i<companyCount; i++){
                NSArray * parsedColumns = [parsedRows[i] componentsSeparatedByString:@","];
                if(parsedColumns != nil){
                    
                    Company* selectedCompany = [self.companyAndProductList objectAtIndex:i];
                    [selectedCompany setAskPrice:[NSString stringWithFormat:@"%@", parsedColumns[1]]];
            
                }
                
            }
            
            //Release NSString
            [myData release];
            
            //switch to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate reloadData];
            });
            
        }
        
    }
    
    //Finish session and reset receivedData
    [self.session invalidateAndCancel];
    self.receivedData = nil;
    
}



#pragma mark NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSLog(@"URLSession:dataTask:didRecevieData \n");
    
    if(data != nil){
        
        if(self.receivedData == nil){
            self.receivedData = [[[NSMutableData alloc]initWithData:data] autorelease];
        }
        else{
            [self.receivedData appendData:data];
        }
    }

}


#pragma mark Other 

- (void)dealloc {
    [self.companyAndProductList removeAllObjects];
    [_companyAndProductList release];
    [_asyncAPI release];
    [_session release];
    [_receivedData release];
    [super dealloc];
}


@end
