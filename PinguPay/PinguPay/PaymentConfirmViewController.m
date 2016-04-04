//
//  PaymentConfirmViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "PaymentConfirmViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface PaymentConfirmViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listOfMethodsTableView;
@property (nonatomic, strong) NSArray *titleStrings;
@property (nonatomic, strong) NSArray *subTitleStrings;


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
    
    self.subTitleStrings = @[
                             @"Card No: xxxx-1234",
                             @"Card No: xxxx-5678",
                             @"Ready to use",
                             @"Balance: USD 20.56",
                             @"Balance: USD 320.72",
                             @"Bank A/C No: xxxx-3543"
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
    NSInteger count;
    if(indexPath.section == 0)
    {
        count = indexPath.row;
    }
    else if(indexPath.section == 1)
    {
        count = 2 + indexPath.row;
    }
    else if(indexPath.section == 2)
    {
        count = 5 + indexPath.row;
    }
    
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:2];
    title.text = self.titleStrings[count];
    
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:3];
    detail.text = self.subTitleStrings[count];
    
    return cell;
}

- (IBAction)ConfirmPressed:(UIButton *)sender
{

//    LAContext *myContext = [[LAContext alloc] init];
//    NSError *authError = nil;
//    NSString *myLocalizedReasonString = @"Authenticate using your finger";
//    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
//        
//        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//                  localizedReason:myLocalizedReasonString
//                            reply:^(BOOL succes, NSError *error) {
//                                
//                                if (succes) {
//                                    
//                                    NSLog(@"User is authenticated successfully");
//                                } else {
//                                    
//                                    switch (error.code) {
//                                        case LAErrorAuthenticationFailed:
//                                            NSLog(@"Authentication Failed");
//                                            break;
//                                            
//                                        case LAErrorUserCancel:
//                                            NSLog(@"User pressed Cancel button");
//                                            break;
//                                            
//                                        case LAErrorUserFallback:
//                                            NSLog(@"User pressed \"Enter Password\"");
//                                            break;
//                                            
//                                        default:
//                                            NSLog(@"Touch ID is not configured");
//                                            break;
//                                    }
//                                    
//                                    NSLog(@"Authentication Fails");
//                                }
//                            }];
//    } else {
//        NSLog(@"Can not evaluate Touch ID");
//    
//    }

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.frame = sender.frame;
    sender.hidden = YES;
    [self.view addSubview:indicator];
    [indicator setColor:[UIColor lightGrayColor]];
    [indicator startAnimating];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Transaction Successful"
                                                                                 message:@"Your transaction has been successfully processesed. Feel free to close this app."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)cancelPressed:(UIButton *)sender
{
}

@end
