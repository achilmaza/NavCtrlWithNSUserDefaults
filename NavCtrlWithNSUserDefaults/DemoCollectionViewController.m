//
//  DemoCollectionViewController.m
//  NavCtrl
//
//  Created by Angie Chilmaza on 8/11/15.
//  Copyright (c) 2015 Angie Chilmaza. All rights reserved.
//

#import "DemoCollectionViewController.h"
#import "DemoChildCollectionViewController.h"
#import "CollectionViewCell.h"
#import "CompanyDAO.h"
#import "Company.h"

@interface DemoCollectionViewController ()


@end

@implementation DemoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mobile device makers";
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationController.editing = NO;
    
    UINib * cellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.companyDAO = [CompanyDAO sharedDAOInstance];
    
    //Company DAO handles the asynchronous call to get stock prices
    //Assigns ViewController as the delegate to notify when to reload
    //data on tableview
    self.companyDAO.delegate = self;
    
    //Setup gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(longPressGestureRecognized:)];
    
    longPress.numberOfTouchesRequired = 1;
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    [longPress release];
    
}


#pragma mark LongPressGestureRecognizer

-(void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Delete Company?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self.companyDAO deleteCompanyAtIndex:[indexPath row]];
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

- (void)longPressGestures:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    
    static UIView       *snapshot = nil;        // A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; // Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                CollectionViewCell *cell = (CollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                [snapshot retain];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                [self.companyDAO moveCompany:[sourceIndexPath row] toIndex:[indexPath row]];
            
                // ... move the rows.
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                
            }
            break;
        }
        default: {
            // Clean up.
            CollectionViewCell *cell = (CollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                [snapshot release];
                snapshot = nil;
                
            }];
            break;
        }
    }
    
}

// Add this at the end of your .m file. It returns a customized snapshot of a given view.
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return [snapshot autorelease];
}


#pragma mark  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.companyDAO getCompanyCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //bottom border
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.3, cell.frame.size.width, 0.3)];
    bottomBorder.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:bottomBorder];
    [bottomBorder release];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    Company*company = [self.companyDAO getCompanyAtIndex:[indexPath row]];
    
    NSString*labelText;
    NSString*priceLabelText;
    
    labelText = [NSString stringWithFormat:@"%@", [company name]];
    cell.label.text = labelText;
    
    if([company askPrice] != nil){
        priceLabelText = [NSString stringWithFormat:@"Price: %@", [company askPrice]];
        cell.subLabel.text = priceLabelText;
    }
    
    UIImage* image = [UIImage imageNamed:[company logo]];
    [cell.imageView setImage:image];
    
    return cell;
}

#pragma mark CompanyDAOProtocol
-(void)reloadData{
    
    [self.collectionView reloadData];
}


#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoChildCollectionViewController * childController = [[DemoChildCollectionViewController alloc] initWithNibName:@"DemoChildCollectionViewController" bundle:nil];

    childController.selectedCompany = [self.companyDAO getCompanyAtIndex:[indexPath row]];
    [self.navigationController pushViewController:childController animated:YES];
    
    [childController release];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    return NO;
}


#pragma mark Other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_companyDAO release];
    [super dealloc];
}


@end
