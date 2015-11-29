//
//  LoginViewController.m
//  PinguPay
//
//  Created by Pratham Mehta on 28/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

static NSString * const kUUID = @"1";


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
    self.loginButton.readPermissions = @[@"public_profile",
                                         @"email",
                                         @"user_friends"];
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
    
    [FBSDKAccessToken setCurrentAccessToken:result.token];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"name,email,picture"}] //@{@"fields":@"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 
                 [appDelegate.meteorClient callMethodName:@"registerCustomer"
                                               parameters:@[[result objectForKey:@"name"],
                                                            [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"],
                                                            kUUID]
                                         responseCallback:nil];
                 
             }
             else
             {
                 NSLog(@"ERROR %@",error.localizedDescription);
             }
         }];
    }
    
//    [self performSegueWithIdentifier:@"loginDone" sender:self];
    
    
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Logged out!");
}

@end
