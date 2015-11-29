//
//  ScanACodeViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "ScanACodeViewController.h"
#import "CDZQRScanningViewController.h"
#import "PaymentConfirmViewController.h"


@interface ScanACodeViewController ()
{
    BOOL yo;
}

@end

@implementation ScanACodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!yo)
    {
        CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
        UINavigationController *scanningNavVC = [[UINavigationController alloc] initWithRootViewController:scanningVC];
        // configure the scanning view controller:
        scanningVC.resultBlock = ^(NSString *result) {
            NSLog(@"Scanned: %@", result);
        
            [scanningNavVC dismissViewControllerAnimated:YES completion:^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                NSString *query = result;
                NSLog(@"Parameter string: %@",query);
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                    NSArray *parts = [param componentsSeparatedByString:@"="];
                    if([parts count] < 2) continue;
                    [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
                }

                
                PaymentConfirmViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"payVC"];
                [self presentViewController:vc animated:YES completion:^{
                    vc.amountLabel.text = [params objectForKey:@"amount"];
                }];
            }];
        };
        scanningVC.cancelBlock = ^() {
            [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
        };
        scanningVC.errorBlock = ^(NSError *error) {
            // todo: show a UIAlertView orNSLog the error
            [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
        };
        
        scanningNavVC.modalPresentationStyle = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIModalPresentationFullScreen : UIModalPresentationFormSheet;
        [self presentViewController:scanningNavVC animated:YES completion:nil];
        
        yo = YES;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
