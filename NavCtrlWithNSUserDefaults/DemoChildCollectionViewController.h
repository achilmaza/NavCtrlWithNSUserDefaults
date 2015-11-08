//
//  DemoChildCollectionViewController.h
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "Company.h"


@interface DemoChildCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) Company* selectedCompany;

@end
