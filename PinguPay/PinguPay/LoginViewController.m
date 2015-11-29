//
//  LoginViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 28/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "LoginViewController.h"
static NSString * const kUUID = @"A495FFFF-C5B1-4B44-B512-1370F02D74DE";


@interface LoginViewController () <FBSDKLoginButtonDelegate>

@property (nonatomic, strong) FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectZero];
    self.loginButton.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    self.loginButton.delegate = self;
    [self.view addSubview:self.loginButton];
    self.loginButton.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"Facebook logged in!");
    [self performSegueWithIdentifier:@"loginDone" sender:self];
    [FBSDKAccessToken setCurrentAccessToken:result.token];
    
    
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Logged out!");
}

@end
