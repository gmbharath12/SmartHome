//
//  Device.m
//  SmartHome
//
//  Created by Bharath G M on 2/18/15.
//  Copyright (c) 2015 Bharath G M. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize deviceId,deviceName;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.deviceName = nil;
        self.deviceId = nil;
    }
    return self;
}


@end
