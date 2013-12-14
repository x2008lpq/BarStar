//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarMapViewController.h"
#import "BarUtility.h"
#import "BarPostPhotoViewController.h"
@interface BarMapViewController ()

@end

@implementation BarMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
    
	// Do any additional setup after loading the view.
}

-(void)dealloc
{
    [tableView release];
    [searchArray release];
    
    [super dealloc];
    
}

-(void) initControls
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], 200)];
    mapView.delegate =self;
    [mapView setShowsUserLocation:YES];
    
    [self.view addSubview:mapView];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self setupCoordsUsingAddress:@"Calgary"];

    
    titleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10,10,[BarUtility SCREEN_WIDTH] - 20,25 )];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Choose your bar";
    titleLabel.alpha = 0.5;
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [mapView addSubview:titleLabel];

    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mapView.frame.size.height + mapView.frame.origin.y , [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT] -(mapView.frame.size.height + mapView.frame.origin.y + 50) ) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];

    
    
}
- (CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end
{
    CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
    CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    CLLocationDistance retVal = [startLoc distanceFromLocation:endLoc];
    [startLoc release];
    [endLoc release];
    
    return retVal;
}

-(void)setupCoordsUsingAddress:(NSString *)address {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
//     }];
//    MKMapRect mRect = mapView.visibleMapRect;
//    MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
//    MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
//    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
//    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
//    CLLocationDistance diameter = [self getDistanceFrom:neCoord to:swCoord];
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter: mapView.centerCoordinate radius:(diameter/2) identifier:@"mapWindow"];
//
//    
//     [geocoder geocodeAddressString:address inRegion:region completionHandler:^(NSArray *placemarks, NSError *error)
//    {
        
        if(error) {
            
            NSLog(@"FAILED to obtain geocodeAddress String. Error : %@", error);
            abort();
            
        } else if(placemarks && placemarks.count > 0) {
            
            // Find all bars...
            [self issueLocalSearchLookup:@"bars" usingPlacemarksArray:placemarks];
            
        }
    }];
    
    
}




#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
    
    
    [mv setRegion:region animated:YES];
    
    
    MKAnnotationView *aV;
    for (aV in views) {
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
        
    }
    
    
    
}



- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    Annotation *annot = [[Annotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //..Whatever you want to happen when the dragging starts or stops
    annotationView.draggable = YES;
}




-(void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks {
    
    // Search 0.250km from point for stores.
    //CLPlacemark *placemark = placemarks[0];
    // CLLocation *location = placemark.location;
    
    // self.coords = mapView.userLocation.coordinate;
    self.coords =  mapView.userLocation.coordinate;
    // location.coordinate;
    
    // Set the size (local/span) of the region (address, w/e) we want to get search results for.
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001250, 0.001250);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span);   // self.coords   mapView.userLocation.coordinate
    
    [self.mapView setRegion:region animated:YES];
    
    
    
    // Create the search request
    self.localSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.localSearchRequest.region = region;
    self.localSearchRequest.naturalLanguageQuery = searchString;
    
    // Perform the search request...
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:self.localSearchRequest];
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        if(error){
            
            NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
            return;
            
        } else {
            
            // We are here because we have data!  Yay..  a whole 10 records of it too *flex*
            // Do whatever with it here...
              searchArray = [[NSMutableArray alloc]init];
            
            for(MKMapItem *mapItem in response.mapItems){
                
                // Show pins...
                NSString *city = mapItem.placemark.addressDictionary[@"City"];
                NSString *CountryCode = mapItem.placemark.addressDictionary[@"CountryCode"];

                
                if([city caseInsensitiveCompare:@"calgary"] == NSOrderedSame  &&([CountryCode caseInsensitiveCompare:@"ca"] == NSOrderedSame))

                {
                    NSLog(@"city in map %@",mapItem.placemark.addressDictionary);
                    
                    NSMutableArray *annotations = [[NSMutableArray array] init ];
                    
                    
                    Annotation *annotation = [[Annotation alloc] initWithCoordinate: mapItem.placemark.location.coordinate];
                    
                    annotation.tag = [searchArray count];
                    
                    annotation.title = mapItem.name;
                    annotation.subtitle = mapItem.placemark.addressDictionary[(NSString *)kABPersonAddressStreetKey];
                    [mapView addAnnotation:annotation];
                    
                    [self.mapView addAnnotations:annotations];
                    
                    [searchArray addObject:mapItem];

                }
                              
            }
            
          
            [tableView reloadData];
            

            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
            MKCoordinateRegion region = MKCoordinateRegionMake(self.coords, span);
            [self.mapView setRegion:region animated:YES];
        }
    }];
    
    
}






- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[Annotation class]])
        return nil;
    
    Annotation *myAnnotation = (Annotation *)annotation;
    
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"CustomAnnotationView"];
    
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
 
    
    
    int tag = [sender tag];
    
    MKMapItem *item = [searchArray objectAtIndex:tag];
    
    
    BarPostPhotoViewController *postVc = [[BarPostPhotoViewController alloc]initWithMapItem:item];
    [self.navigationController pushViewController:postVc animated:YES];
    [postVc release];
NSLog(@"annotation tapped");
}





-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{    
    
}


#pragma mark - Tableview delgate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [searchArray count];
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell1 %d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier]autorelease];
        
    }
    MKMapItem *item = [searchArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.name;  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSString *street = item.placemark.addressDictionary[@"Street"];
    NSString *location = [NSString stringWithFormat:@"%@", street];
    

    cell.detailTextLabel.hidden = NO;
    
    cell.detailTextLabel.text = location;
    
    
    return cell;

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKMapItem *item = [searchArray objectAtIndex:indexPath.row];
    
  
    BarPostPhotoViewController *postVc = [[BarPostPhotoViewController alloc]initWithMapItem:item];
    [self.navigationController pushViewController:postVc animated:YES];
    [postVc release];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
