//
//  RestAPI.h
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

@class RestAPI;
@protocol RestAPIDelegate <NSObject>

-(void) getReceivedData:(NSMutableData*)data sender:(RestAPI*)sender;

@end



@interface RestAPI : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) id <RestAPIDelegate> mDelegate;

-(void)httpRequest: (NSMutableURLRequest*)request;

@end
