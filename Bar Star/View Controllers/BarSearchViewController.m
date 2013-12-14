//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarSearchViewController.h"
#import "BarUtility.h"
#import "BarDetailViewController.h"

@interface BarSearchViewController ()

@end

@implementation BarSearchViewController
@synthesize localSearch,localSearchRequest,coords,mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    self.localSearch = nil;
    self.mapView.delegate = nil;
    self.mapView = nil;
    if(searchArray)
    {
        [searchArray release];
    }
    if(searchBar)
    {
        [searchBar release];
        
    }
    if(searchDisplayCOntroller )
    {
        searchDisplayCOntroller.delegate = nil;
        [searchDisplayCOntroller release];
        searchDisplayCOntroller = nil;
    }
    if(locationManager)
    {
        locationManager.delegate = nil;
        
        [locationManager release];
        locationManager = nil;
    }
    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initControls
{
    mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    mapView.delegate =self;
    [mapView setShowsUserLocation:YES];
    
    [self.view addSubview:mapView];
    
   locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.02;
    mapRegion.span.longitudeDelta = 0.02;
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], 44)];
    searchBar.frame = CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], 44);
    [mapView addSubview:searchBar];
    searchBar.delegate = self;

    
//    [self.mapView setRegion:mapRegion animated: YES];
  searchDisplayCOntroller =   [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    
     [self.searchDisplayController setDelegate:self];
    [searchDisplayCOntroller setSearchResultsDataSource:self];
    [searchDisplayCOntroller setSearchResultsDelegate:self];
    

    
//    [self setupCoordsUsingAddress:@"Calgary"];
    


    
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
  
    if (!userLocation)
        return;
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(0.02, 0.02);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCoordsUsingAddress:@"Calgary"];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
       [self zoomToUserLocation:self.mapView.userLocation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    
    if (!userLocation)
        
        return;
    
    else{
        
        /*
         
         NSLog(@"inside didUpdateUserLocation in else");
         
         MKCoordinateRegion mapRegion;
         mapRegion.center = self.mapView.userLocation.coordinate;
         mapRegion.span.latitudeDelta = 0.02;
         mapRegion.span.longitudeDelta = 0.02;
         
         [self.mapView setRegion:mapRegion animated: YES];
         
         */
        
    }
    
}
#pragma mark - Search Methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel button clicked");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar {
    
    // Cancel any previous searches.
    [localSearch cancel];
    
    
    
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //request.naturalLanguageQuery = searchBar.text;
    request.naturalLanguageQuery = [NSString stringWithFormat:@"%@ %s", searchBar.text, "bar"];
    NSLog(@"request.naturalLanguageQuery: %@", request.naturalLanguageQuery);
    request.region = self.mapView.region;
    
    [self StartHandle];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        
        
        if (error != nil) {
            [self EndHandle];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!",nil)
                                        message: @"No Results...try again :)" //[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [self EndHandle];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        
        
        results = response;
      
        searchArray = [[NSMutableArray alloc]init];

        for(MKMapItem *mapItem in results.mapItems){
            
            // Show pins...
            
            //   NSMutableArray *annotations = [[NSMutableArray array] init ];
            NSMutableArray *annotations = [[NSMutableArray array] init ];
            
            Annotation *annotation = [[Annotation alloc] initWithCoordinate: mapItem.placemark.location.coordinate];
            annotation.tag = [searchArray count];
            annotation.title = mapItem.name;
            annotation.subtitle = mapItem.placemark.addressDictionary[(NSString *)kABPersonAddressStreetKey];
            //  NSLog(@"Name for result: = %@", mapItem.name);
            [mapView addAnnotation:annotation];

            
            [self.mapView addAnnotations:annotations];
            [searchArray addObject:mapItem];
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        [self EndHandle];
    }];
}



- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
//    MKCoordinateRegion region;
//    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
//    
//    
//    [mv setRegion:region animated:YES];
//    
//    NSLog(@"did annotation view called");
//    MKAnnotationView *aV;
//    for (aV in views) {
//        CGRect endFrame = aV.frame;
//        
//        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.45];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [aV setFrame:endFrame];
//        [UIView commitAnimations];
//        
//        
//    }
    
    
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //..Whatever you want to happen when the dragging starts or stops
    annotationView.draggable = YES;
}



-(void)setupCoordsUsingAddress:(NSString *)address {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error) {
            
            NSLog(@"FAILED to obtain geocodeAddress String. Error : %@", error);
            abort();
            
        } else if(placemarks && placemarks.count > 0) {
            
            // Find all bars...
            [self issueLocalSearchLookup:@"bars" usingPlacemarksArray:placemarks];
            
        }
    }];
    
    
}


-(void)StartHandle{
	if (handleProcess) {
		[self EndHandle];
	}
	if (handleProcess != nil) {
		return;
	}
	handleProcess = [[HandleProcess alloc] initWithParentView:self.navigationController.view];
	
	if (handleProcess && [handleProcess respondsToSelector:@selector(ShowProcessView)]) {
		[handleProcess ShowProcessView];
	}
}

-(void)EndHandle{
	if (handleProcess && [handleProcess respondsToSelector:@selector(HideProcessView)]) {
		[handleProcess HideProcessView];
		[handleProcess release];
		handleProcess = nil;
	}
}


-(void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks {
    
    
    [self StartHandle];
    self.coords =  mapView.userLocation.coordinate;

//    CLPlacemark *placemark = placemarks[0];
//     CLLocation *location = placemark.location;
//    self.coords =  location.coordinate;

    
    
//    CLLocationCoordinate2D calgaryLocation = CLLocationCoordinate2DMake(51.5, 114.5);
    
    // Set the size (local/span) of the region (address, w/e) we want to get search results for.
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001250, 0.001250);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span);
//    MKCoordinateRegion region = MKCoordinateRegionMake(calgaryLocation, span);

    [mapView setRegion:region animated:YES];
    
//    NSLog(@"set region coordinate %f %f",calgaryLocation.latitude,calgaryLocation.longitude);

    // Create the search request
    self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.localSearchRequest.region = region;
    self.localSearchRequest.naturalLanguageQuery = searchString;
    
    // Perform the search request...
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        if(error){
            [self EndHandle];
            NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
            return;
            
        } else {
             [self EndHandle];
            // We are here because we have data!  Yay..  a whole 10 records of it too *flex*
            // Do whatever with it here...
           
            searchArray = [[NSMutableArray alloc]init];

            for(MKMapItem *mapItem in response.mapItems){
                
                // Show pins...
                
                NSMutableArray *annotations = [[NSMutableArray array] init ];
                
                
                Annotation *annotation = [[Annotation alloc] initWithCoordinate: mapItem.placemark.location.coordinate];
                annotation.tag = [searchArray count];
                
                annotation.title = mapItem.name;
                annotation.subtitle = mapItem.placemark.addressDictionary[(NSString *)kABPersonAddressStreetKey];
                [mapView addAnnotation:annotation];
                //  NSLog(@"Name for result: = %@", mapItem.name);
                
                [self.mapView addAnnotations:annotations];
                
                [searchArray addObject:mapItem];
       
            }
            
            [searchDisplayCOntroller.searchResultsTableView reloadData];
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(self.coords, span);
            [self.mapView setRegion:region animated:YES];
            [self EndHandle];

        }
    }];

    
}


#pragma mark - MKMapViewDelegate methods.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[Annotation class]])
        return nil;
    
    Annotation *myAnnotation = (Annotation *)annotation;

    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"CustomAnnotationView"];
    annotationView.canShowCallout = YES;
    
    UIButton *btnViewVenue = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btnViewVenue.tag = myAnnotation.tag;
    
    [btnViewVenue addTarget:self action:@selector(handleSelectedAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView=btnViewVenue;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.multipleTouchEnabled = NO;
    
    
    return annotationView;
}

-(void)handleSelectedAnnotation:(id)sender
{
    NSLog(@"annotation tapped");
    int tag = [sender tag];
    
    if([searchArray count] > tag)
    {
        MKMapItem *item = [searchArray objectAtIndex:tag];
        
        NSLog(@"selected place %@",item.placemark.addressDictionary);
        
        NSString *street = item.placemark.addressDictionary[@"Street"];
        NSString *city = item.placemark.addressDictionary[@"City"];
        NSString *location = [NSString stringWithFormat:@"%@", street];
        StreamEntity *entity = [[StreamEntity  alloc]init];
        entity.barTitle = item.name;
        entity.address = location;
        entity.cityName = city;
        entity.latitude = [NSString stringWithFormat:@"%f", item.placemark.coordinate.latitude];
        entity.longitude = [NSString stringWithFormat:@"%f", item.placemark.coordinate.longitude];

        BarDetailViewController *detailVc = [[BarDetailViewController alloc]initWithEntity:entity];
        
        [self.navigationController pushViewController:detailVc animated:YES];
        [detailVc release];
        [entity release];

    }
  
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER]autorelease];
    }
    
    MKMapItem *item = [searchArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKMapItem *item = [searchArray objectAtIndex:indexPath.row];
    
    
    NSLog(@"change the coordinate %f %f",item.placemark.location.coordinate.latitude,item.placemark.location.coordinate.longitude);
    [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    
    //   [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
       
    
}





@end
