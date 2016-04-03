//
//  HomeTableViewController.h
//  PinguPay
//
//  Created by Siddharth Gupta on 11/29/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeteorClient.h"
#import "ObjectiveDDP.h"
#import "M13OrderedDictionary.h"

@interface HomeTableViewController : UITableViewController


@property MeteorClient *meteorClient;
@property (strong) ObjectiveDDP *ddp;

@property (strong, nonatomic) M13MutableOrderedDictionary *collection;


@end
