//
//  SettingsManager.h
//  Paranoid Fan
//
//  Created by Adeel Asim on 9/2/15.
//  Copyright © 2015 Paranoid Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingManager : NSObject

//- (void)saveSignUpUserName:(NSString *)userName;
- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc;

@end
