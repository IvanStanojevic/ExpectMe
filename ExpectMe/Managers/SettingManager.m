//
//  SettingsManager.m
//  Paranoid Fan
//
//  Created by Adeel Asim on 9/2/15.
//  Copyright © 2015 Paranoid Fan. All rights reserved.
//

#import "SettingManager.h"

//#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

@implementation SettingManager

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree + 180;
    } else {
        return 360 + degree + 180;
    }
}
@end
