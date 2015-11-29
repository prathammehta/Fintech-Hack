//
//  RaiseInvoiceTableViewController.m
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "RaiseInvoiceTableViewController.h"
#import "ProcessingTransactionViewController.h"

@interface RaiseInvoiceTableViewController ()


@end

@implementation RaiseInvoiceTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProcessingTransactionViewController *vc = segue.destinationViewController;
    vc.qrString = @"id=10D39AE7-020E-4467-9CB2-DD36366F899D&amount=350";
}

@end
