//
//  RestAPI.m
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "RestAPI.h"

@interface RestAPI()

@property (nonatomic, strong) NSMutableData* mReceivedData;
@property (nonatomic, strong) NSURLConnection* mRequestedConnection;

@end


@implementation RestAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //self.mReceivedData = [[NSMutableData alloc]init];
        //self.mRequestedConnection   = [[NSURLConnection alloc]init];
        
    }
    return self;
}

-(void) httpRequest:(NSMutableURLRequest*) request{

   NSLog(@"HttpRequest.... \n");
   self.mRequestedConnection = [NSURLConnection connectionWithRequest:request delegate:self];
      
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if(data != nil){
        
        if(self.mReceivedData == nil){
            self.mReceivedData = [[[NSMutableData alloc]initWithData:data] autorelease];
        }
        else{
            [self.mReceivedData appendData:data];
        }
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"connection:didReceiveResponse: %@\n", response);
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connectionDidFinishLoading %@ \n", connection);
    
    [self.mDelegate getReceivedData:self.mReceivedData sender:self];
    self.mDelegate = nil;
    self.mRequestedConnection = nil;
    [_mReceivedData release];
    self.mReceivedData = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"connection:didFailWithError %@\n", error.description);
    
}

- (void)dealloc {
 
    [_mRequestedConnection release];
    [super dealloc];
}

@end
