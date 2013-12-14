//Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/MapKit.h>
@class BarSplashViewController;

@interface BarAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BarSplashViewController *viewController;

@property(nonatomic,retain) UINavigationController *mainNc;

@property (nonatomic, retain) NSArray *permissions;
@property (strong, nonatomic) FBSession *session;

-(void) initializeNavigationController;

@end
