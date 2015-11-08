//
//  DemoCollectionViewController.h
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "RestAPI.h"
#import "CompanyDAO.h"


@interface DemoCollectionViewController : UICollectionViewController <CompanyDAOProtocol, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CompanyDAO * companyDAO;

@end
