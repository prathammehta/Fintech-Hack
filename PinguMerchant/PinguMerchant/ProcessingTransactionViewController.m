//
//  ProcessingTransactionViewController.m
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "ProcessingTransactionViewController.h"

@interface ProcessingTransactionViewController ()


@end

@implementation ProcessingTransactionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator.color = [UIColor darkGrayColor];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.qrCodeImage.image = [[UIImage alloc] initWithCIImage:[self createQRForString:self.qrString]];
}

- (void)setQrString:(NSString *)qrString
{
    _qrString = qrString;
    self.qrCodeImage.image = [[UIImage alloc] initWithCIImage:[self createQRForString:qrString]];
}

- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    return qrFilter.outputImage;
}

- (IBAction)donePressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
