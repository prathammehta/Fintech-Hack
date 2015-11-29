//
//  CustomersCollectionViewController.m
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "CustomersCollectionViewController.h"

@interface CustomersCollectionViewController ()

@end

@implementation CustomersCollectionViewController

static NSString * const reuseIdentifier = @"customerCell";


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.layer.cornerRadius = 60;
    imageView.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    [cell setBackgroundColor:[UIColor colorWithRed:0.9
                                             green:0.9
                                              blue:0.9
                                             alpha:1]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"customerTapped" sender:self];
}

@end
