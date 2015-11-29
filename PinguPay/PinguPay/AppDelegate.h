//
//  AppDelegate.h
//  PinguPay
//
//  Created by Pratham Mehta on 28/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ObjectiveDDP.h"
#import <CoreLocation/CoreLocation.h>
#import "MeteorClient.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property MeteorClient *meteorClient;
@property CLLocationManager *locationManager;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong) ObjectiveDDP *ddp;


@end

