//
//  DemoChildCollectionViewController.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "DemoChildCollectionViewController.h"
#import "ThirdViewController.h"
#import "CollectionViewCell.h"
#import "CompanyDAO.h"
#import "Product.h"

@interface DemoChildCollectionViewController ()

@end

@implementation DemoChildCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationController.editing = NO;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register cell classes
    UINib * cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //Setup gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    
    [longPress release];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    self.title = [self.selectedCompany name];
    
}


#pragma mark LongPressureGestureRecognizer

-(void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    NSLog(@"gesture = %@ \n", gesture);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Delete Product?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         CompanyDAO * dao = [CompanyDAO sharedDAOInstance];
                                                         [dao deleteCompanyProduct:self.selectedCompany atIndex:[indexPath row]];
                                                         
                                                         NSArray* deleteRow = [[NSArray alloc]initWithObjects:indexPath, nil];
                                                         [self.collectionView deleteItemsAtIndexPaths:deleteRow];
                                                         [self.collectionView reloadData];
                                                         [deleteRow release];
                                                         
                                                     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //do nothing
                                                         }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}





#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.selectedCompany getProductCount];;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    //bottom border
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.3, cell.frame.size.width, 0.3)];
    bottomBorder.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:bottomBorder];
    [bottomBorder release];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // Configure the cell...
    Product* selectedProduct = [self.selectedCompany getProductAtIndex:[indexPath row]];
    cell.label.text = [selectedProduct name];
    UIImage* image = [UIImage imageNamed:[selectedProduct logo]];
    [cell.imageView setImage:image];
    
    return cell;
}


#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    ThirdViewController * webViewController = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];

    Product* selectedProduct = [self.selectedCompany getProductAtIndex:[indexPath row]];
    NSString * url = [selectedProduct url];
    webViewController.url = [NSURL URLWithString:url];
    
    // Push the view controller.
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [webViewController release];
}


#pragma mark Other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
}


@end
