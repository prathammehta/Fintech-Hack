//
//  ProcessingTransactionViewController.h
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessingTransactionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImage;
@property (nonatomic, strong) NSString *qrString;

@end
