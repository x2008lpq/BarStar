//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarListViewController.h"
#import "BarUtility.h"
#import "BarCustomListCell.h"
#import "BarMapViewController.h"
#import "BarDetailViewController.h"
#import "BarSearchViewController.h"
#import "BarMenuViewController.h"
@interface BarListViewController ()

@end

@implementation BarListViewController
@synthesize barsArray,userLocation;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    

    
    [self initControls];
    [self addButtonsInNavigationbar];
    [self callWebservicesFOrData];
    
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self StartHandle];
    
    [BarServerAPI API_GetAllbarDetails:self];

}

-(void)dealloc
{
    
    [mainView release];
    [streamTableView release];
    [refreshControl release];
    [barsArray release];
    [locationManager release];
    
    [super dealloc];
    
}
-(void) initControls
{
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * refImage = [UIImage imageNamed:[BarUtility LIST_REFRESH_IMAGE]];
    [refreshButton addTarget:self action:@selector(handleRefreshButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    refreshButton.frame = CGRectMake(10, 13, 101, 60);
    [refreshButton setBackgroundImage:refImage forState:UIControlStateNormal];
    
    refreshButton.layer.cornerRadius = 20;
    refreshButton.layer.borderColor = [UIColor clearColor].CGColor;
    refreshButton.layer.borderWidth  = 1;

    
    [mainView addSubview:refreshButton];
    
    
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * camImage = [UIImage imageNamed:[BarUtility LIST_CAMERA_IMAGE]];
    [cameraButton addTarget:self action:@selector(handleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.layer.cornerRadius = 20;
    cameraButton.layer.borderColor = [UIColor clearColor].CGColor;
    cameraButton.layer.borderWidth  = 1;
    cameraButton.frame = CGRectMake(110, 6, 100, 74);
    [cameraButton setBackgroundImage:camImage forState:UIControlStateNormal];
    
       
    
    
    
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImage = [UIImage imageNamed:[BarUtility LIST_SEARCH_IMAGE]];
    
    [searchButton addTarget:self action:@selector(handleSearchButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.layer.cornerRadius = 20;
    searchButton.layer.borderColor = [UIColor clearColor].CGColor;
    searchButton.layer.borderWidth  = 1;
    searchButton.frame = CGRectMake(209, 13, 101, 60);
    [searchButton setImage:searchImage forState:UIControlStateNormal];
    
    [mainView addSubview:searchButton];
    [mainView addSubview:cameraButton];
    
    
   
    

    streamTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, cameraButton.frame.size.height + cameraButton.frame.origin.y + 5, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT] -(cameraButton.frame.size.height + cameraButton.frame.origin.y + 44) ) style:UITableViewStylePlain];
    streamTableView.backgroundColor = [UIColor clearColor];
    
    
   refreshControl =  [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                action:@selector(sortArray)
      forControlEvents:UIControlEventValueChanged];
    
   
    [streamTableView addSubview:refreshControl];
    
    streamTableView.delegate = self;
    streamTableView.dataSource = self;
    
    [mainView addSubview:streamTableView];
    mainView.userInteractionEnabled = YES;
    
   }

-(void) addButtonsInNavigationbar
{
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"topbanner-header.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    navBar.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithTitle:@"menu" style:UIBarButtonItemStylePlain target:self action:@selector(handleMenuButtonEvent:)];
    menuButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = menuButton;

    [[UIBarButtonItem appearance]setTintColor:[UIColor redColor]];
    
}

-(void)handleMenuButtonEvent:(id)sender
{
    BarMenuViewController *menuVc = [[BarMenuViewController alloc]init];
    [self.navigationController pushViewController:menuVc animated:YES];
    [menuVc release];
}
-(void)sortArray
{
    [refreshControl beginRefreshing];
    [BarServerAPI API_GetAllbarDetails:self];

    
}

-(void)handleSearchButtonEvent:(id)sender
{
    BarSearchViewController *mapVc = [[BarSearchViewController alloc]init];
    [self.navigationController pushViewController:mapVc animated:YES];
    [mapVc release];
}
-(void)handleCameraButtonEvent:(id)sender
{
    BarMapViewController *mapVc = [[BarMapViewController alloc]init];
    [self.navigationController pushViewController:mapVc animated:YES];
    [mapVc release];
    
}
-(void)handleRefreshButtonEvent:(id)sender
{
    [self StartHandle];
    
    [BarServerAPI API_GetAllbarDetails:self];
}

#pragma mark - Tableview delgate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [barsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell %d",indexPath.row];
    BarCustomListCell *cell = (BarCustomListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if(cell == nil)
    {
        cell = [[[BarCustomListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        
    }
    
    [cell setValuesForCell:[barsArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BarDetailViewController * detailVc = [[BarDetailViewController alloc]initWithEntity:[barsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detailVc animated:YES];
    [detailVc release];
    
}


#pragma mark - Handlers
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




#pragma mark - Webservice calls
-(void) callWebservicesFOrData
{
    NSString *deviceID = [[UIDevice currentDevice] name];
    
    [self StartHandle];
    
    [BarServerAPI Initialize];
    [BarServerAPI API_RegisterDeviceId:deviceID withDelegate:self];
    [BarServerAPI API_GetAllbarDetails:self];
  
    
    
}
-(void)API_CALLBACK_RegisgterDevice:(NSDictionary *)fbDict
{
    NSLog(@"devie response %@",fbDict);
    
    
}

-(void)API_CALLBACK_GetAllBars:(NSArray *)barArray
{
    
    self.barsArray = [NSMutableArray arrayWithArray:barArray];
    
    [streamTableView reloadData];
    [BarServerAPI API_GetAllBarImagesWithDelegate:self];
    
    [self EndHandle];
}

-(void)API_CALLBACK_GetAllImages:(NSArray *)barImagesArray
{
    
    if([barImagesArray count] == [barsArray count])
    {
        for(int i = 0 ; i < [barsArray count]; i++)
        {
            NSDictionary * dict = [barImagesArray objectAtIndex:i];
            
            StreamEntity *entity = [barsArray objectAtIndex:i];
            entity.photoId = [dict objectForKey:@"IdPhoto"];
            entity.datetime = [dict objectForKey:@"dataLabel"];
              
        }
    }
    if(refreshControl.isRefreshing)
    {
        [streamTableView reloadData];
        [refreshControl endRefreshing];
    }
    [streamTableView reloadData];
  
    
   
}

-(void)API_CALLBACK_ServerError:(NSString *)error
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location 
-(void) stopUpdateLoc{
    [locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [manager location];
    // Configure the new event with information from the location
    
    float longitude=location.coordinate.longitude;
    float latitude=location.coordinate.latitude;

    CLLocationCoordinate2D barLocation = CLLocationCoordinate2DMake(latitude, longitude);

    
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:barLocation];
    geoCoder.delegate = self;
    [geoCoder start];
    
    userLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userLocation];
    [prefs setObject:data forKey:@"userLocation"];
    [prefs setFloat:longitude forKey:@"longitude"];
    [prefs setFloat:latitude forKey:@"latitude"];

    
//    NSLog(@"lat long updated %f,%f",latitude,longitude);
    
    [streamTableView reloadData];
    
}


// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    MKPlacemark * myPlacemark = placemark;
    NSLog(@"listt address %@",myPlacemark.addressDictionary);
    // with the placemark you can now retrieve the city name
    NSString * barCity = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    NSString * barCountryCode= [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryCodeKey];

    NSLog(@"bar cty in list %@",barCity);
    
    [prefs setObject:barCity forKey:@"UserCity"];
     [prefs setObject:barCountryCode forKey:@"UserCountryCode"];
    
    
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}




@end
