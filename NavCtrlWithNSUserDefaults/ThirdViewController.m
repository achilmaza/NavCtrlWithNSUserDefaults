//
//  ThirdViewController.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "ThirdViewController.h"

@import WebKit;

@interface ThirdViewController ()

@property (nonatomic, retain) WKWebView *webView;

@end

@implementation ThirdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init] ;
    self.webView = [[[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration] autorelease];
    [theConfiguration release];
    
    //[self.view addSubview: self.webView];
    self.view = self.webView;
    
    self.webView.navigationDelegate = self;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    
    [_url release];
    [_webView release];
    [super dealloc];
}

@end
