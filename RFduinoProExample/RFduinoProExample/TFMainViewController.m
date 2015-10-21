//
//  ViewController.m
//  RFduinoProExample
//
//  Created by Michael Bac on 9/29/15.
//  Copyright © 2015 Tech Firma, LLC. All rights reserved.
//

#import "TFMainViewController.h"
#import "TFBluetoothResources.h"
#import "TFDevicesViewController.h"


@interface TFMainViewController () {
	CBCentralManager* _btManager;
	CBPeripheral* _btPeripheral;
	CBService* _btService;
	CBCharacteristic* _btSettingsCharacteristic;
	CBCharacteristic* _btActivityCharacteristic;
	NSUUID* _deviceID;
	
	CAGradientLayer* _actionUpGradient;
	CAGradientLayer* _actionDownGradient;
	CAGradientLayer* _hardwareUpGradient;
	CAGradientLayer* _hardwareDownGradient;

	bool _connected;
	bool _active;
}
@end

@implementation TFMainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.progressView setTransform:CGAffineTransformMakeScale(1.0, 14.0)];
	
	UIImage *image = [[UIImage imageNamed:@"ProgressBkgrnd"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 7, 11, 7)];
	[self.progressView setTrackImage:image];
	image = [[UIImage imageNamed:@"ProgressInd"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 7, 11, 7)];
	[self.progressView setProgressImage:image];

	[self.hardwareButton setTitle:@"ON" forState:UIControlStateSelected];
	
	self.actionButton.layer.cornerRadius = 12;
	self.actionButton.layer.borderWidth = 1;
	self.actionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.actionButton.clipsToBounds = YES;
	
	_actionUpGradient = [CAGradientLayer layer];
	_actionUpGradient.frame = self.actionButton.bounds;
	_actionUpGradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.878 green:0.878 blue:0.816 alpha:1.000].CGColor),(id)([UIColor colorWithRed:0.816 green:0.816 blue:0.690 alpha:1.000].CGColor),nil];
	_actionUpGradient.startPoint = CGPointMake(0.5,0.0);
	_actionUpGradient.endPoint = CGPointMake(0.5,1.0);
	
	_actionDownGradient = [CAGradientLayer layer];
	_actionDownGradient.frame = self.actionButton.bounds;
	_actionDownGradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.816 green:0.816 blue:0.690 alpha:1.000].CGColor),(id)([UIColor colorWithRed:0.878 green:0.878 blue:0.816 alpha:1.000].CGColor),nil];
	_actionDownGradient.startPoint = CGPointMake(0.5,0.0);
	_actionDownGradient.endPoint = CGPointMake(0.5,1.0);

	[self.actionButton.layer insertSublayer:_actionUpGradient atIndex:0];

	self.hardwareButton.layer.borderWidth = 1;
	self.hardwareButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.hardwareButton.clipsToBounds = YES;
	
	_hardwareUpGradient = [CAGradientLayer layer];
	_hardwareUpGradient.frame = self.hardwareButton.bounds;
	_hardwareUpGradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:1.000].CGColor),(id)([UIColor colorWithRed:0.882 green:0.882 blue:0.882 alpha:1.000].CGColor),nil];
	_hardwareUpGradient.startPoint = CGPointMake(0.5,0.0);
	_hardwareUpGradient.endPoint = CGPointMake(0.5,1.0);
	
	_hardwareDownGradient = [CAGradientLayer layer];
	_hardwareDownGradient.frame = self.hardwareButton.bounds;
	_hardwareDownGradient.colors = [NSArray arrayWithObjects:(id)([UIColor colorWithRed:0.0 green:0.882 blue:0.0 alpha:1.000].CGColor),(id)([UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.000].CGColor),nil];
	_hardwareDownGradient.startPoint = CGPointMake(0.5,0.0);
	_hardwareDownGradient.endPoint = CGPointMake(0.5,1.0);

	[self.hardwareButton.layer insertSublayer:_hardwareUpGradient atIndex:0];

	_btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) viewWillAppear:(BOOL)animated {
	_btManager.delegate = self;
	
	_deviceID = [[NSUUID alloc] initWithUUIDString:[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceID"]];

	if( _btManager.state == CBCentralManagerStatePoweredOn )
		[self connect];
}

- (void) viewDidDisappear:(BOOL)animated {
	if( _btPeripheral != nil )
		[_btManager cancelPeripheralConnection:_btPeripheral];
	
	_btPeripheral = nil;
	_btService = nil;
	_btActivityCharacteristic = nil;
	_btSettingsCharacteristic = nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
	if( central.state == CBCentralManagerStatePoweredOn )
	{
		[self connect];
	}
}

-(void) connect {
	NSArray* arrPeripherals;
	
	if( _deviceID != nil ) {
		NSArray* devices = [[NSArray alloc] initWithObjects:_deviceID, nil];
		arrPeripherals = [_btManager retrievePeripheralsWithIdentifiers:devices];
	}
	
	if( ( arrPeripherals != nil ) && ( arrPeripherals.count > 0 ) ) {
		_btPeripheral = [arrPeripherals objectAtIndex:0];
		_btPeripheral.delegate = self;
		
		[_btManager connectPeripheral:_btPeripheral options:nil];
	} else {
		[_btManager scanForPeripheralsWithServices:@[[TFBluetoothResources getServiceUUID]] options:nil];
	}
}

- (void) centralManager:(CBCentralManager*) central didDiscoverPeripheral:(CBPeripheral*) peripheral advertisementData:(NSDictionary*) advertisementData RSSI:(NSNumber*) RSSI {

	_btPeripheral = peripheral;
	_btPeripheral.delegate = self;
	
	[_btManager stopScan];
	[_btManager connectPeripheral:_btPeripheral options:nil];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	NSLog(@"Peripheral connected");
	
	[self updateDeviceStatus:true];
	
	[_btPeripheral discoverServices:@[[TFBluetoothResources getServiceUUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError*)error {
	NSLog(@"Peripheral disconnected: %@", [error localizedDescription]);
	
	[self updateDeviceStatus:false];
}

- (void)peripheral:(CBPeripheral *) peripheral didDiscoverServices:(NSError *) error {
	if( error ) {
		NSLog(@"Error discovering services: %@", [error localizedDescription]);
		return;
	}
	
	// Loop through the newly filled peripheral.services array, just in case there's more than one.
	for( CBService* service in peripheral.services ) {
		if ([[service UUID] isEqual:[TFBluetoothResources getServiceUUID]]) {
			_btService = service;
			break;
		}
	}
	
	[peripheral discoverCharacteristics:@[[TFBluetoothResources getSettingsUUID], [TFBluetoothResources getActivityUUID]] forService:_btService];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	// Deal with errors (if any)
	if( error ) {
		NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
		return;
	}
	
	for( CBCharacteristic* characteristic in service.characteristics ) {
		// And check if it's the right one
		if( [characteristic.UUID isEqual:[TFBluetoothResources getSettingsUUID]] ) {
			_btSettingsCharacteristic = characteristic;
		}
		else if( [characteristic.UUID isEqual:[TFBluetoothResources getActivityUUID]] ) {
			_btActivityCharacteristic = characteristic;
			
			[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		}
	}
}

- (void) peripheral:(CBPeripheral*) peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic*) characteristic error:(NSError*) error {
	if( error )
		NSLog( @"Error changing notification state: %@", error.localizedDescription );
	
	if( ![characteristic isEqual:_btActivityCharacteristic])
		return;
	
	// Notification has started
	if( characteristic.isNotifying ) {
		NSLog( @"Notification began on %@", characteristic );
	}
}

- (void) peripheral:(CBPeripheral*) peripheral didWriteValueForCharacteristic:(CBCharacteristic*) characteristic error:(NSError*) error {
	if( error )
		NSLog( @"Error writing characteristic value: %@", [error localizedDescription]);
}

- (void) peripheral:(CBPeripheral*) peripheral didUpdateValueForCharacteristic:(CBCharacteristic*) characteristic error:(NSError*) error {
	if( error ) {
		NSLog( @"Error updating value for characteristic: %@", [error localizedDescription] );
		return;
	}
	
	if( [characteristic isEqual:_btActivityCharacteristic] ) {
		unsigned char* data = ( unsigned char* ) characteristic.value.bytes;
		
		switch( data[ 0 ] ) {
			case 0x01:                              // Button State byte code
				if (data[1] == 0x00) {
					[self.hardwareButton setSelected:true];
					[self.hardwareButton.layer replaceSublayer:_hardwareUpGradient with:_hardwareDownGradient];
				} else {
					[self.hardwareButton setSelected:false];
					[self.hardwareButton.layer replaceSublayer:_hardwareDownGradient with:_hardwareUpGradient];
				}
				break;
			case 0x03:
			{
				// LDR analog value byte code
				int ldr = (((int) data[1]) << 8 ) + (((int) data[2]) & 0xff);
				
				self.ldrLabel.text = [[NSString alloc] initWithFormat:@"%i", ldr];
				self.progressView.progress = ( float ) ldr / ( float ) 1023;
				break;
			}
			case 0x04:                              // Sleep Mode byte code
				if (data[1] == 0x00) {                  // 0 = 'awake', 1 = 'asleep'
					[self updateDeviceSleepState:false];
				} else {
					[self updateDeviceSleepState:true];
				}
				break;
		}
	}
}

-(void) writeCharacteristic:(unsigned char[ ] ) bytes {
	NSData* data = [NSData dataWithBytes:bytes length:2];
	
	[_btPeripheral writeValue:data forCharacteristic:_btSettingsCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) updateDeviceStatus:(bool) connected {
	_connected = connected;
	
	if(connected) {
		NSString* name = [[NSUserDefaults standardUserDefaults] stringForKey:_btPeripheral.identifier.UUIDString];
		
		if( name.length == 0 ) {
			name = _btPeripheral.name;
		}
		
		self.deviceName.text = name;
		self.deviceName.textColor = [UIColor blackColor];
		
		self.actionButton.enabled = true;
	} else {
		self.deviceName.text = @"DISCONNECTED";
		self.deviceName.textColor = [UIColor redColor];

		[self updateDeviceSleepState:false];
	}
}

-(void) updateDeviceSleepState:(bool) sleepState {
	if(_connected) {
		if(sleepState) {
			self.deviceSleepState.text = @"Asleep (press button to awaken)";
			self.deviceSleepState.textColor = [UIColor redColor];
			self.actionButton.enabled = false;
		} else {
			self.deviceSleepState.text = @"Awake";
			self.deviceSleepState.textColor = [UIColor blackColor];
			self.actionButton.enabled = true;
		}
	} else {
		self.deviceSleepState.text = @"Waiting for connection...";
		self.deviceSleepState.textColor = [UIColor blackColor];
		self.actionButton.enabled = false;
	}
}

- (IBAction)touchDown:(UIButton *)sender
{
	unsigned char data[ ] = { 0x02, 0x01 };
	
	[self writeCharacteristic:data];
	
	[self.actionButton.layer replaceSublayer:_actionUpGradient with:_actionDownGradient];
}


- (IBAction)touchUp:(UIButton *)sender
{
	unsigned char data[ ] = { 0x02, 0x00 };
	
	[self writeCharacteristic:data];

	[self.actionButton.layer replaceSublayer:_actionDownGradient with:_actionUpGradient];
}

- (IBAction)touchUpOutside:(UIButton *)sender
{
	[self touchUp:sender];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( _btPeripheral != nil ) {
		[_btManager cancelPeripheralConnection:_btPeripheral];
		_btPeripheral = nil;
	}
	
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if( [[segue identifier] isEqualToString:@"Devices"] ) {
		TFDevicesViewController* view = [segue destinationViewController];
		
		view.btManager = _btManager;
	}
}

- (IBAction)onAction:(UIBarButtonItem *)sender {
	NSString* status = @"Connect";
	
	if( _connected )
		status = @"Disconnect";
	
	UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil
																   message:nil
																  preferredStyle:UIAlertControllerStyleActionSheet];
	actionSheet.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
 
	UIAlertAction* action = [UIAlertAction actionWithTitle:status style:UIAlertActionStyleDefault
												   handler:^(UIAlertAction * action) {
													   if( _connected ) {
														   if (_btPeripheral != nil) {
															   [_btManager cancelPeripheralConnection:_btPeripheral];
														   }
													   } else {
														   if( _btPeripheral != nil ) {
															   [_btManager connectPeripheral:_btPeripheral options:nil];
														   }
													   }
												   }];
	[actionSheet addAction:action];
	
	action = [UIAlertAction actionWithTitle:@"Devices" style:UIAlertActionStyleDefault
									handler:^(UIAlertAction * action) {
										[self performSegueWithIdentifier:@"Devices" sender:self];
									}];
	[actionSheet addAction:action];
	
	action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
	[actionSheet addAction:action];
	
	[self presentViewController:actionSheet animated:YES completion:nil];
}

@end
