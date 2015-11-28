//
//  AddPaymentMethodCollectionViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 28/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "AddPaymentMethodCollectionViewController.h"

@interface AddPaymentMethodCollectionViewController ()
{
    NSArray *sources;
}

@end

@implementation AddPaymentMethodCollectionViewController

//static NSString * const reuseIdentifier = @"paymentMethodCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    sources = @[
                @"PayPal",
                @"Chase",
                @"VISA",
                @"MasterCard",
                @"CurrentC",
                @"Google wallet",
                @"ApplePay",
                @"AmEx",
                ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(donePressed)];
}

- (void) donePressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"paymentMethodCell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ldp.png",(long)indexPath.row+1]];
    
    cell.layer.cornerRadius = 10.0;
    cell.layer.masksToBounds = YES;
    cell.clipsToBounds = YES;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:3];
    label.text = sources[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIView *view = [cell.contentView viewWithTag:1];
    view.alpha = 0.3;
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell.contentView viewWithTag:2];
    [cell.contentView addSubview:activity];
    activity.hidden = NO;
    activity.center = cell.contentView.center;
    [activity startAnimating];
    
    [cell.contentView viewWithTag:4].layer.cornerRadius = 20.0;
    [cell.contentView viewWithTag:4].layer.masksToBounds = YES;
    [cell.contentView viewWithTag:4].clipsToBounds = YES;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        activity.hidden = YES;
        [self performSegueWithIdentifier:@"addAccountSegue" sender:self];
        
    });
    
    dispatch_time_t checkTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(checkTime, dispatch_get_main_queue(), ^(void){
        [cell.contentView viewWithTag:4].hidden = NO;
    });
}
@end
