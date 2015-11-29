//
//  CustomersCollectionViewController.m
//  PinguMerchant
//
//  Created by Pratham Mehta on 29/11/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "CustomersCollectionViewController.h"

static NSString * const kUUID = @"A495FFFF-C5B1-4B44-B512-1370F02D74DE";
static NSString * const kIdentifier = @"Vehicle";
static void * const kRangingOperationContext = (void *)&kRangingOperationContext;
static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;



@interface CustomersCollectionViewController ()
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) NSArray *detectedBeacons;
@property (nonatomic, unsafe_unretained) void *operationContext;


@end

@implementation CustomersCollectionViewController

static NSString * const reuseIdentifier = @"customerCell";

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.meteorClient = [[MeteorClient alloc] initWithDDPVersion:@"pre2"];
    //[self.meteorClient addSubscription:@"awesome_server_mongo_collection"];
    ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"ws://192.168.15.18:3000/websocket" delegate:self.meteorClient];
    self.meteorClient.ddp = ddp;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportConnection) name:MeteorClientDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportConnectionReady) name:MeteorClientConnectionReadyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportDisconnection) name:MeteorClientDidDisconnectNotification object:nil];
    
    
    [self.meteorClient.ddp connectWebSocket];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self startRangingForBeacons];
}

- (void)startRangingForBeacons
{
    self.operationContext = kRangingOperationContext;
    
    [self createLocationManager];
    
    self.detectedBeacons = [NSArray array];
    [self turnOnRanging];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    [manager stopRangingBeaconsInRegion:region];
    
    NSLog(@"Beacons: %@", [beacons description]);
    
    NSMutableArray *customerMinorIDs = [[NSMutableArray alloc] init];
    for (CLBeacon *beacon in beacons){
        [customerMinorIDs addObject:beacon.minor];
    }
    
    self.detectedBeacons = beacons;
    
    [self.meteorClient callMethodName:@"currentCustomersInStore" parameters:@[kUUID, customerMinorIDs] responseCallback:^(NSDictionary *response, NSError *error) {
        NSLog(@"sent customers to server");
        
        [manager startRangingBeaconsInRegion:region];
    }];
    
    [self.collectionView reloadData];
}

- (void)createLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
}

- (void)turnOnRanging
{
    NSLog(@"Turning on ranging...");
    
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Couldn't turn on ranging: Ranging is not available.");
        return;
    }
    
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion);
}

- (void)createBeaconRegion
{
    if (self.beaconRegion)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    

}

- (void)reportConnection {
    NSLog(@"Connecting to Meteor Server");
}

- (void)reportConnectionReady {
    NSLog(@"CONNECTED to Meteor Server!");
}

- (void)reportDisconnection {

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.detectedBeacons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    imageView.layer.cornerRadius = 60;
    imageView.layer.masksToBounds = YES;
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    [cell setBackgroundColor:[UIColor colorWithRed:0.9
                                             green:0.9
                                              blue:0.9
                                             alpha:1]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"customerTapped" sender:self];
}



@end
