//
//  UsernamePasswordTableViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 28/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "UsernamePasswordTableViewController.h"

@interface UsernamePasswordTableViewController ()

@end

@implementation UsernamePasswordTableViewController

- (IBAction)donePressed:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
