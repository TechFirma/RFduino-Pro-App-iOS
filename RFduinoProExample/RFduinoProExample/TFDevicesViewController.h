//
//  TFDevicesViewController.h
//  Shooter Ready
//
//  Created by Michael Bac on 6/29/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CBCentralManager.h>
#import "TFDeviceCell.h"

@interface TFDevicesViewController : UITableViewController<UITableViewDataSource, CBCentralManagerDelegate, TFDeviceCellDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) CBCentralManager* btManager;
@property (strong, nonatomic) IBOutlet UITableView *devicesTable;

@end
