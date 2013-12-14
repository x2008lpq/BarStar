//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"
#import "AddressBook/AddressBook.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Annotation.h"
#import "HandleProcess.h"

@interface BarSearchViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MKMapView *mapView;

    UISearchBar *searchBar;
    CLLocationManager *locationManager;
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
    CLLocationCoordinate2D currentCentre;
    UISearchDisplayController *searchDisplayCOntroller;
    NSMutableArray *searchArray;
    HandleProcess *handleProcess;

}
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchRequest *localSearchRequest;
@property CLLocationCoordinate2D coords;
@property (strong, nonatomic)  MKMapView *mapView;

@end
