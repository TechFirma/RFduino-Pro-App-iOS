//
//  TFBluetoothResources.h
//  Shooter Ready
//
//  Created by Michael Bac on 7/11/14.
//  Copyright (c) 2014 Tech Firma, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CBUUID.h>

@interface TFBluetoothResources : NSObject

+(CBUUID*) getServiceUUID;
+(CBUUID*) getActivityUUID;
+(CBUUID*) getCharacteristicConfigUUID;
+(CBUUID*) getSettingsUUID;

@end
