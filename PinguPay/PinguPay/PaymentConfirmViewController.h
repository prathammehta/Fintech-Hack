//
//  PaymentConfirmViewController.h
//  PinguPay
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentConfirmViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic) BOOL bypassConfirm;
@property (strong, nonatomic) IBOutlet UILabel *merchantName;
@end
