//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"
#import "AddressBook/AddressBook.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Annotation.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kGOOGLE_API_KEY @"AIzaSyAQ-WtnFyn5nCIp5qLdiNvzGAS4CYRUud8"

@interface BarMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D currentCentre;
    UILabel *titleLabel;
    MKMapView *mapView;
    UITableView *tableView;
    MKLocalSearchResponse *results;

    NSMutableArray *searchArray;
    
}
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property CLLocationCoordinate2D coords;
@property CLLocation *myLoc;
@property (strong, nonatomic)  MKMapView *mapView;
@end
