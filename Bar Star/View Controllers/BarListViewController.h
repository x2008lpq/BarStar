//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BarServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreLocation/CoreLocation.h"
#import "HandleProcess.h"
@interface BarListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ServerAPIViewDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>

{
    UIImageView *mainView;
    
    UIButton *refreshButton;
    UIButton *cameraButton;
    UIButton *searchButton;
    UITableView *streamTableView;
    UIRefreshControl *refreshControl ;
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D currentCentre;
    
    HandleProcess *handleProcess;

    
}
@property (strong, nonatomic) CLLocation *userLocation;

@property(nonatomic,retain) NSMutableArray *barsArray;

@end
