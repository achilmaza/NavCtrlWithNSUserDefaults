//
//  CollectionViewCell.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)dealloc {
    [_label release];
    [_imageView release];
    [_subLabel release];
    [super dealloc];
}
@end
