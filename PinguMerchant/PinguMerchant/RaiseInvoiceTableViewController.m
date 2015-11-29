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

@property (weak, nonatomic) IBOutlet UITextField *amountField;

@end

@implementation RaiseInvoiceTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProcessingTransactionViewController *vc = segue.destinationViewController;
    vc.qrString = [NSString stringWithFormat:@"=10D39AE7-020E-4467-9CB2-DD36366F899D&amount=%@",self.amountField.text];
}

@end
