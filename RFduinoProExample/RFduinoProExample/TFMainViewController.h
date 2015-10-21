//
//  ViewController.h
//  RFduinoProExample
//
//  Created by Michael Bac on 9/29/15.
//  Copyright © 2015 Tech Firma, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CBCentralManager.h>
#import <CoreBluetooth/CBPeripheral.h>
#import <CoreBluetooth/CBService.h>
#import <CoreBluetooth/CBCharacteristic.h>

@interface TFMainViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *deviceSleepState;
@property (strong, nonatomic) IBOutlet UILabel *ldrLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIButton *hardwareButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;

@end

