//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarSplashViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "BarAppDelegate.h"
#import "CoreLocation/CoreLocation.h"

@interface BarSplashViewController ()

@end

@implementation BarSplashViewController

@synthesize loginLabel,logoImageView,mainView,headerImage;

@synthesize fbookId;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}


- (void)dealloc
{
    self.mainView = nil;
    self.logoImageView = nil;
    self.headerImage = nil;
    self.loginLabel = nil;
    

    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initControls];
    
	// Do any additional setup after loading the view.
}

-(void) initControls
{
   
    UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [tempView setImage:[UIImage imageNamed:[BarUtility SPLASH_SCREEN_BG]]];
    
    self.mainView = tempView;
    [tempView release];
    
    [self.view addSubview:mainView];
    
    
    UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  [BarUtility SCREEN_WIDTH], [BarUtility SPLASH_HEADER_IMAGE_HEIGHT])];
    
    [tempImageView setImage:[UIImage imageNamed:[BarUtility SPLASH_HEADER_IMAGE]]];
    
    self.headerImage = tempImageView;
    [tempImageView release];
    
    [mainView addSubview:headerImage];
    
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [BarUtility SPLASH_LOGIN_LABEL_ORIGIN_Y], [BarUtility SCREEN_WIDTH], 21)];
    [tempLabel setTextAlignment:NSTextAlignmentCenter];
    [tempLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[BarUtility SPLASH_LOGIN_LABEL_IMAGE]]]];
    
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont systemFontOfSize:17];
    
    self.loginLabel = tempLabel;
    [tempLabel release];
    [mainView addSubview:loginLabel];
    
    
    FBLoginView* loginView = [[FBLoginView alloc]init];
    loginView.delegate = self;
    
    loginView.frame = CGRectOffset(loginView.frame, 85, [BarUtility SPLASH_LOGIN_BUTTON_ORIGIN_Y]);
    [self.view addSubview:loginView];
    [loginView sizeToFit];

    
    UIImage * logoImage =[UIImage imageNamed:[BarUtility SPLASH_LOGO_IMAGE]];
    
    float imageW = logoImage.size.width/15;
    float imageH = logoImage.size.height/15;
    
    UIImageView *tempLogo = [[UIImageView alloc]initWithFrame:CGRectMake([BarUtility SCREEN_WIDTH]/2 - imageW/2 , [BarUtility SCREEN_HEIGHT] - (imageH ), imageW, imageH)];
    [tempLogo setImage:logoImage];
    self.logoImageView = tempLogo;
    [tempLogo release];
    
    [mainView addSubview:logoImageView];
    
    mainView.userInteractionEnabled = YES;
    self.loginLabel.text =   @"Login with Facebook to Enter.";
    BarAppDelegate *appdelegate = (BarAppDelegate *)[[UIApplication sharedApplication ]delegate];
    
}

-(void) handleLoginEvent
{
    
}

-(void) navigateToMainScreen
{
    
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




#pragma mark - FB DELEGATES
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
     self.loginLabel.text =   @"Login with Facebook to Enter.";
    isLogginFirstTime = YES;
    
}

// once the user has logged in using Facebook run the refresh calls to check userID in database (for Disclaimer check)
- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
    self.loginLabel.text = [NSString stringWithFormat:@"Hey %@! You may Enter", user.first_name];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:user.first_name  forKey:@"userName"];
    [prefs setObject:user.id  forKey:@"fbookID"];

    self.fbookId = user.id;
    //call service
    [self StartHandle];
    [BarServerAPI Initialize];
    [BarServerAPI API_RegisterWithFbookId:user.id withDelegate:self];
    
    

   
    
    
}

-(void)API_CALLBACK_RegisterWithFB:(NSMutableArray *)fbookIdArray
{
    [self EndHandle];
    
    if([fbookIdArray count] == 0)
    {
        
        [self StartHandle];
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Calgary/Canada"]];
        NSString *dateTIme = [formatter stringFromDate:now];

        
        NSString *deviceID = [[UIDevice currentDevice] name];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //insert fb
        [BarServerAPI API_InsertWithFbookId:fbookId withDelegate:self withFbookName:[prefs objectForKey:@"userName"] withDate:dateTIme withDeviceId:deviceID];
        
        [formatter release];
        
    }
    // move to next screen

    else
    {
        BarAppDelegate *appdelegate = (BarAppDelegate *)[[UIApplication sharedApplication ]delegate];
        
        [appdelegate initializeNavigationController];
    }
    
    
    
    
    
}

-(void)API_CALLBACK_InsertWithFB:(NSArray *)fbookIdArray
{
    NSLog(@"insert aray %@",fbookIdArray);
    BarAppDelegate *appdelegate = (BarAppDelegate *)[[UIApplication sharedApplication ]delegate];
    
    [appdelegate initializeNavigationController];
    [self checkFbook];
    
}

-(void)API_CALLBACK_ServerError:(NSString *)error
{
    [self EndHandle];

}


// load the discalimer message if no Facebook ID matching the users is found in the database
- (void) checkFbook{
    
    if(isLogginFirstTime)
    {
       
            [[[UIAlertView alloc]initWithTitle:@"Welcome to Barstar!"
                                       message:@"Please verify that you are at least 18 years old."
                                      delegate:nil
                             cancelButtonTitle:@"Verify"
                             otherButtonTitles: nil] show];
    }
    
}



- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
