//
//  HomeTableViewController.m
//  PinguPay
//
//  Created by Siddharth Gupta on 11/29/15.
//  Copyright © 2015 PinguPay Inc. All rights reserved.
//

#import "HomeTableViewController.h"
#import "PaymentConfirmViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>


#define CUSTOMER_ID 2

static NSString * const kUUID = @"A495FFFF-C5B1-4B44-B512-1370F02D74DE";
static NSString * const kIdentifier = @"Customer";
static void * const kRangingOperationContext = (void *)&kRangingOperationContext;
static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;



@interface HomeTableViewController () <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property CBCentralManager *cbManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.meteorClient = [[MeteorClient alloc] initWithDDPVersion:@"1"];
    [self.meteorClient addSubscription:@"ordersForMe" withParameters:@[@CUSTOMER_ID]];
    ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"ws://192.168.1.103:3000/websocket" delegate:self.meteorClient];
    self.meteorClient.ddp = ddp;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportConnection) name:MeteorClientDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportConnectionReady) name:MeteorClientConnectionReadyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportDisconnection) name:MeteorClientDidDisconnectNotification object:nil];
    
    [self.meteorClient.ddp connectWebSocket];
    
    [self startAdvertisingBeacon];
    
    self.navigationItem.titleView = [[NSBundle mainBundle] loadNibNamed:@"NavbarHeaderView" owner:self options:nil].firstObject;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAddedUpdate:)
                                                 name:@"added"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveRemovedUpdate:)
                                                 name:@"removed"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveChangeUpdate:)
                                                 name:@"changed"
                                               object:nil];
}

- (void) didReceiveAddedUpdate:(NSNotification *)update {
    [self checkForOrders];
}

- (void) checkForOrders {
    M13MutableOrderedDictionary *currentOrders = [self.meteorClient.collections objectForKey:@"OrdersCollection"];
    int count = [currentOrders count];
    
    if(count){
        NSDictionary *order = currentOrders[count - 1];
        NSNumber *customer = [order objectForKey:@"customer"];
        NSNumber *approved = [order objectForKey:@"approved"];
        NSNumber *amount = [order objectForKey:@"amount"];
        
        if(customer.intValue == CUSTOMER_ID && approved.boolValue == NO){
            PaymentConfirmViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"payVC"];
            vc.amount = [NSString stringWithFormat:@"%@",amount];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

- (void) didReceiveRemovedUpdate:(id)update {
    [self checkForOrders];
}

- (void) didReceiveChangeUpdate:(id)update {
    [self checkForOrders];
}

- (void)startAdvertisingBeacon
{
    NSLog(@"Turning on advertising...");
    
    [self createBeaconRegion];
    
    if (!self.peripheralManager)
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    [self turnOnAdvertising];
}
- (void)createBeaconRegion
{
    if (self.beaconRegion)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
}

- (void) setUpLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
   // NSLog(@"You Entered A Region. Current count: %lu", (unsigned long)[self.detectedBeacons count]);
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
   // NSLog(@"You Exited a beacon. Current Count: %lu", (unsigned long)[self.detectedBeacons count]);
    
}

- (void)turnOnAdvertising
{
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral manager is off.");
//        [self performSegueWithIdentifier:@"nobluetooth" sender:self];
        return;
    }
    
    time_t t;
    srand((unsigned) time(&t));
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconRegion.proximityUUID
                                                                     major:0
                                                                     minor:CUSTOMER_ID
                                                                identifier:self.beaconRegion.identifier];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    NSLog(@"Turning on advertising for region: %@.", region);
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral manager is off.");
        return;
    }
    
    NSLog(@"Peripheral manager is on.");
    [self turnOnAdvertising];
}

- (void)reportConnection {
    NSLog(@"Connecting to Meteor Server");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)reportConnectionReady {
    NSLog(@"CONNECTED to Meteor Server!");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.collection = self.meteorClient.collections[@"OrdersCollection"];
}

- (void)reportDisconnection {
    NSLog(@"------------------- DISCONNECTED to Meteor Server!");
}

@end
