//
//  TFDevicesViewController.m
//  Shooter Ready
//
//  Created by Michael Bac on 6/29/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import "TFDevicesViewController.h"
#import "TFDeviceCell.h"
#import "TFBluetoothResources.h"
#import "CoreBluetooth/CBPeripheral.h"

@interface TFDevicesViewController ()
{
	NSMutableArray* _btPeripherals;
	NSMutableArray* _deviceNames;
	bool _scanning;
}

@end

@implementation TFDevicesViewController

@synthesize btManager;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.devicesTable.dataSource = self;
	
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;

	_scanning = false;
	btManager.delegate = self;
	_btPeripherals = [[NSMutableArray alloc] init];
	_deviceNames = [[NSMutableArray alloc] init];
	
	if (btManager.state == CBCentralManagerStatePoweredOn)
		[self onActionButtonPressed:self.actionButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
	if( central.state == CBCentralManagerStatePoweredOn ) {
		[self onActionButtonPressed:self.actionButton];
	}
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:peripheral.identifier.UUIDString];
	
	if (name.length == 0) {
		name = peripheral.name;
	}
	
	[_btPeripherals addObject:peripheral];
	[_deviceNames addObject:name];
	
	[self.tableView reloadData];
}

- (IBAction)onActionButtonPressed:(UIBarButtonItem *)sender {
	if( _scanning ) {
		self.actionButton.title = @"Scan";
		
		[btManager stopScan];
		[self.activityIndicator stopAnimating];
	} else {
		self.actionButton.title = @"Stop";
		
		[_btPeripherals removeAllObjects];
		[_deviceNames removeAllObjects];
		
		[btManager scanForPeripheralsWithServices:@[[TFBluetoothResources getServiceUUID]] options:nil];
		[self.activityIndicator startAnimating];
	}
	
	_scanning = !_scanning;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_btPeripherals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TFDeviceCell *cell = ( TFDeviceCell* ) [tableView dequeueReusableCellWithIdentifier:@"Devices" forIndexPath:indexPath];
	
	if (cell == nil) {
		cell = ( TFDeviceCell* ) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Devices"];
	}

	cell.viewController = self;
	cell.delegate = self;
	
	cell.rfduinoImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	CBPeripheral* peripheral = [_btPeripherals objectAtIndex:indexPath.row];
	NSString* name = [_deviceNames objectAtIndex:indexPath.row];
    
	cell.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	cell.nameLabel.text = name;
	cell.nameLabel.tag = indexPath.row;
	
	cell.uuidLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	cell.uuidLabel.adjustsFontSizeToFitWidth = true;
	
	NSString* identifier = [peripheral.identifier.UUIDString substringFromIndex:24];
    cell.uuidLabel.text = identifier;
	
	cell.renameButton.layer.cornerRadius = 8;
	cell.renameButton.layer.borderWidth = 1;
	cell.renameButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
	cell.renameButton.clipsToBounds = YES;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[btManager stopScan];
	
	CBPeripheral* peripheral = [_btPeripherals objectAtIndex:indexPath.row];

	[[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:@"DeviceID"];
	
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TFDeviceCellDelegate

-(void)nameChanged:(TFDeviceCell *)cell newName:(NSString *)name {
	NSInteger row = cell.nameLabel.tag;
	
	CBPeripheral* peripheral = [_btPeripherals objectAtIndex:row];
	[_deviceNames replaceObjectAtIndex:row withObject:name];
	
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:peripheral.identifier.UUIDString];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[btManager stopScan];
}

@end
