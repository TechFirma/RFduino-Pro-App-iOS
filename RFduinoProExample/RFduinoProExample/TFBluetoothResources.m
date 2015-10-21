//
//  TFBluetoothResources.m
//  Shooter Ready
//
//  Created by Michael Bac on 7/11/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import "TFBluetoothResources.h"

static NSString* RFDUINO_SERVICE = @"00002220-0000-1000-8000-00805f9b34fb";
static NSString* RFDUINO_ACTIVITY = @"00002221-0000-1000-8000-00805f9b34fb";
static NSString* CLIENT_CHARACTERISTIC_CONFIG = @"00002902-0000-1000-8000-00805f9b34fb";
static NSString* RFDUINO_SETTINGS = @"00002222-0000-1000-8000-00805f9b34fb";

@implementation TFBluetoothResources

+(CBUUID*) getServiceUUID
{
	return [CBUUID UUIDWithString:RFDUINO_SERVICE];
}

+(CBUUID*) getActivityUUID
{
	return [CBUUID UUIDWithString:RFDUINO_ACTIVITY];
}

+(CBUUID*) getCharacteristicConfigUUID
{
	return [CBUUID UUIDWithString:CLIENT_CHARACTERISTIC_CONFIG];
}

+(CBUUID*) getSettingsUUID
{
	return [CBUUID UUIDWithString:RFDUINO_SETTINGS];
}

@end
