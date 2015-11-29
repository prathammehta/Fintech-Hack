//
//  PaymentConfirmViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "PaymentConfirmViewController.h"

@interface PaymentConfirmViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listOfMethodsTableView;
@property (nonatomic, strong) NSArray *titleStrings;

@end

@implementation PaymentConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listOfMethodsTableView.delegate = self;
    self.listOfMethodsTableView.dataSource = self;
    [self.listOfMethodsTableView reloadData];
    
    self.titleStrings = @[
                          @"Barclays Platinum",
                          @"Chase Saphire",
                          @"Apple Pay",
                          @"PayPal",
                          @"Google Wallet",
                          @"Citi bank"
                          ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        case 1:
            return 3;
            break;
            
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"CREDIT CARDS";
            break;
        case 1:
            return @"WALLETS";
            break;
        case 2:
            return @"BANK TRANSFER";
            break;
        default:
            break;
    }
    return @"Undefined.";
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell"];
    return cell;
}



@end
