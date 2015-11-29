//
//  CustomersCollectionViewController.h
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MeteorClient.h"
#import "ObjectiveDDP.h"

@interface CustomersCollectionViewController : UICollectionViewController <CLLocationManagerDelegate>

@property MeteorClient *meteorClient;
@property CLLocationManager *locationManager;
@property (strong) ObjectiveDDP *ddp;

@end
