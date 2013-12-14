//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarDetailViewController.h"
#import "BarUtility.h"
#import "BarReviewViewController.h"
#import "BarSearchViewController.h"
#import "BarMapViewController.h"
#import "BarViewPhotoViewController.h"
#import "BarMenuViewController.h"
#import "BarListViewController.h"
@interface BarDetailViewController ()

@end

@implementation BarDetailViewController

@synthesize entity,barCity;

- (id)initWithEntity:(StreamEntity *)aentity
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.entity = aentity;

    }
    return self;
}
-(void)dealloc
{
   [mainView release];
    [mainScrollView release];
    [titleLabel release];
    [addressLabel release];
    [imagesView release];
    
    [votesView release];
   [overallVotesView release];
    [percentageLabel release];
    [likeItLabel release];
   [reviewsView release];
   [reviewsScrollView release];
   [imagesIdArray release];

    
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self isnearToCalgaryLocation];

    [self addTopButtons];
    [self createImageView];
    [self createVotesView];
    [self createReviewsView];
    [self addButtonsInNavigationbar];

	// Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [BarServerAPI Initialize];
    [self StartHandle];
    [BarServerAPI API_GetOverAllVotes:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"]];
   
    
    [BarServerAPI API_GetAllReviews:self forBarName:titleLabel.text];
}
-(void) addTopButtons
{
    posY = 0;
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView addSubview:mainScrollView];
    
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * refImage = [UIImage imageNamed:[BarUtility LIST_REFRESH_IMAGE]];
    [refreshButton addTarget:self action:@selector(handleRefreshButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    refreshButton.frame = CGRectMake(10, 13, 101, 60);
    [refreshButton setBackgroundImage:refImage forState:UIControlStateNormal];
    
    [mainScrollView addSubview:refreshButton];
    
    
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * camImage = [UIImage imageNamed:[BarUtility LIST_CAMERA_IMAGE]];
    [cameraButton addTarget:self action:@selector(handleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    cameraButton.frame = CGRectMake(110, 6, 100, 74);
    [cameraButton setBackgroundImage:camImage forState:UIControlStateNormal];
    
    
    
    
    
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImage = [UIImage imageNamed:[BarUtility LIST_SEARCH_IMAGE]];
    [searchButton addTarget:self action:@selector(handleSearchButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    searchButton.frame = CGRectMake(209, 13, 101, 60);
    [searchButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    
    [mainScrollView addSubview:searchButton];
    [mainScrollView addSubview:cameraButton];
    posY = posY + cameraButton.frame.size.height + cameraButton.frame.origin.y;
    
    int posX = 10;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 25)];
    [mainScrollView addSubview:titleLabel];
    
    posY = posY + titleLabel.frame.size.height ;
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 20)];
    [mainScrollView addSubview:addressLabel];
    titleLabel.backgroundColor  = [UIColor clearColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0xE8B619);
    addressLabel.textColor = UIColorFromRGB(0x919395);

    titleLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = entity.barTitle;
    addressLabel.text = entity.address;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    addressLabel.font = [UIFont boldSystemFontOfSize:15];
    posY = posY + addressLabel.frame.size.height + 10;
    
    mainScrollView.userInteractionEnabled = YES;
    

}

-(void) createImageView
{
    imagesView = [[BarImagesView alloc]initWithFrame:CGRectMake(20, posY, [BarUtility SCREEN_WIDTH]-40, [BarUtility DETAIL_IMAGEVIEW_HEIGHT])];
    
    imagesView.delegate = self;
    [mainScrollView addSubview:imagesView];
    
    posY = posY + imagesView.frame.size.height + 10;
    
    [BarServerAPI API_GetSelectedBarImagesWithDelegate:self withBarName:titleLabel.text];
    
}

-(void) createVotesView
{
    votesView = [[UIView alloc]initWithFrame:CGRectMake(10, posY, [BarUtility SCREEN_WIDTH]-20, 100)];
    votesView.layer.cornerRadius = 10;
    votesView.layer.borderColor = [UIColor clearColor].CGColor;
    votesView.layer.borderWidth  = 1;
    votesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greyback.png"]];
    

    int votePosy = 5;
    [mainScrollView addSubview:votesView];
   
    UILabel* votetitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,votePosy,votesView.frame.size.width - 50,20 )];
    votetitleLabel.textAlignment = NSTextAlignmentLeft;
    votetitleLabel.textColor = UIColorFromRGB(0xE8B619);
    votetitleLabel.text = @"OVERALL VOTES";
    votetitleLabel.font = [UIFont boldSystemFontOfSize:16];
    votetitleLabel.backgroundColor = [UIColor clearColor];
    
    [votesView addSubview:votetitleLabel];
    
    votePosy = votePosy + votetitleLabel.frame.size.height;
    
    overallVotesView =  [[UILabel alloc]initWithFrame:CGRectMake(0,votePosy,votesView.frame.size.width - 100,20 )];
    overallVotesView.textAlignment = NSTextAlignmentCenter;
    overallVotesView.textColor = [UIColor whiteColor];
    overallVotesView.text = @"0 people voted";
    overallVotesView.font = [UIFont boldSystemFontOfSize:15];
    
    [votesView addSubview:overallVotesView];
    votePosy = votePosy + overallVotesView.frame.size.height;
    
    percentageLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0,votePosy,votesView.frame.size.width - 100,20 )];
    percentageLabel.textAlignment = NSTextAlignmentCenter;
    percentageLabel.textColor = [UIColor whiteColor];
    percentageLabel.text = @"0 %";
    percentageLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [votesView addSubview:percentageLabel];

    
    votePosy = votePosy + percentageLabel.frame.size.height;
    
    likeItLabel =  [[UILabel alloc]initWithFrame:CGRectMake(100,votePosy,votesView.frame.size.width - 150,20 )];
    likeItLabel.textAlignment = NSTextAlignmentLeft;
    likeItLabel.textColor = [UIColor whiteColor];
    likeItLabel.text = @"like it";
    likeItLabel.font = [UIFont systemFontOfSize:14];
    
    [votesView addSubview:likeItLabel];
    
    votetitleLabel.backgroundColor = [UIColor clearColor];
    overallVotesView.backgroundColor = [UIColor clearColor];
    percentageLabel.backgroundColor = [UIColor clearColor];
    likeItLabel.backgroundColor = [UIColor clearColor];


    undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.frame = CGRectMake(5, votePosy, 73, 20);
    [undoButton setTitle:@"undo vote" forState:UIControlStateNormal];
    
    [undoButton addTarget:self action:@selector(handleUndoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    undoButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    [undoButton setBackgroundImage:[UIImage imageNamed:[BarUtility DETAIL_UNDO_BUTTON_IMAGE]] forState:UIControlStateNormal];
    
    [votesView addSubview:undoButton];
    
    undoButton.hidden = YES;
    undoButton.titleLabel.textColor = [ UIColor blackColor];

    
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(overallVotesView.frame.size.width + 10,  overallVotesView.frame.origin.y, 73, 27);
    [likeButton setTitle:@"like" forState:UIControlStateNormal];
    
    [likeButton addTarget:self action:@selector(handleLikeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    likeButton.titleLabel.textColor = [ UIColor blackColor];
    
    likeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];

    [likeButton setBackgroundImage:[UIImage imageNamed:[BarUtility DETAIL_LIKE_BUTTON_IMAGE]] forState:UIControlStateNormal];

    [votesView addSubview:likeButton];

    
    
    dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dislikeButton.frame = CGRectMake(overallVotesView.frame.size.width + 10, likeButton.frame.size.height + likeButton.frame.origin.y + 5, 73, 27);
    [dislikeButton setTitle:@"dislike" forState:UIControlStateNormal];
    
    [dislikeButton addTarget:self action:@selector(handleDislikeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    dislikeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];

    [dislikeButton setBackgroundImage:[UIImage imageNamed:[BarUtility DETAIL_DISLIKE_BUTTON_IMAGE]] forState:UIControlStateNormal];
    dislikeButton.titleLabel.textColor = [ UIColor blackColor];

    [votesView addSubview:dislikeButton];

    

    [votetitleLabel release];
    
    
    posY = posY + votesView.frame.size.height + 10;
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, votesView.frame.size.height + votesView.frame.origin.y + 50);
    mainView.userInteractionEnabled = YES;
    
    
    [undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [BarServerAPI API_GetOverAllVotes:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"]];
    
}

-(void) createReviewsView
{
    reviewsView = [[UIView alloc]initWithFrame:CGRectMake(10, posY, [BarUtility SCREEN_WIDTH]-20, 150)];
    reviewsView.layer.cornerRadius = 10;
    reviewsView.layer.borderColor = [UIColor clearColor].CGColor;
    reviewsView.layer.borderWidth  = 1;
    reviewsView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greyback.png"]];
    
    int reviewPosy = 5;
    [mainScrollView addSubview:reviewsView];
    
    UILabel* reviewtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,reviewPosy,reviewsView.frame.size.width - 50,20 )];
    reviewtitleLabel.textAlignment = NSTextAlignmentLeft;
    reviewtitleLabel.textColor = UIColorFromRGB(0xE8B619);
    reviewtitleLabel.text = @"USER UPDATE";
    reviewtitleLabel.font = [UIFont boldSystemFontOfSize:16];
    reviewtitleLabel.backgroundColor = [UIColor clearColor];
    
    [reviewsView addSubview:reviewtitleLabel];
    
    reviewPosy = reviewPosy + reviewtitleLabel.frame.size.height;
    [reviewtitleLabel release];

    
    reviewsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, reviewPosy, reviewsView.frame.size.width - 20, reviewsView.frame.size.height - reviewPosy - 10)];
    reviewsScrollView.backgroundColor = [UIColor whiteColor];
    
    [reviewsView addSubview:reviewsScrollView];
    reviewsScrollView.layer.cornerRadius = 10;
    reviewsScrollView.layer.borderColor = [UIColor clearColor].CGColor;
    reviewsScrollView.layer.borderWidth = 2;
    
    posY = posY + reviewsView.frame.size.height + 10;

   
    addReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addReviewButton.frame = CGRectMake(mainScrollView.frame.size.width/2 - 106/2,posY, 106, 27);
    [addReviewButton setTitle:@"add review" forState:UIControlStateNormal];
    
    [addReviewButton addTarget:self action:@selector(handleAddReviewButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    addReviewButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    
    [addReviewButton setBackgroundImage:[UIImage imageNamed:[BarUtility DETAIL_ADD_REVIEW_BUTTON_IMAGE]] forState:UIControlStateNormal];
    
    
     [mainScrollView addSubview:addReviewButton];
    if([self.barCity caseInsensitiveCompare:@"calgary"] == NSOrderedSame)
    {
        
        addReviewButton.hidden = NO;
        mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y + 50);
    }
    
    else
    {
        addReviewButton.hidden = YES;

        mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y);

    }
    
  
    
    
    [self StartHandle];
    [BarServerAPI API_GetAllReviews:self forBarName:titleLabel.text];

    
    
}


-(BOOL)isnearToCalgaryLocation
{
    
    float latitude = [entity.latitude floatValue];
    float longitude = [entity.longitude floatValue];
    CLLocationCoordinate2D barLocation = CLLocationCoordinate2DMake(latitude, longitude);

    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:barLocation];
    geoCoder.delegate = self;
    [geoCoder start];

    return YES;
    
};



// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
   self.barCity = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"detail  address %@",myPlacemark.addressDictionary);

        NSString * barCountryCode= [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryCodeKey];
    
    
    
      NSString *UserCountryCode = [prefs objectForKey:@"UserCountryCode"];
    NSString *userCity = [prefs objectForKey:@"UserCity"];
    
    
   if(([barCountryCode caseInsensitiveCompare:@"CA"] == NSOrderedSame) && ([UserCountryCode caseInsensitiveCompare:@"CA"]== NSOrderedSame))
   {
    if(([self.barCity caseInsensitiveCompare:@"calgary"] == NSOrderedSame) && ([userCity caseInsensitiveCompare:@"calgary"]== NSOrderedSame))
    {
        addReviewButton.hidden = NO;
        mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y + 50);
    }
    
    else
    {
        addReviewButton.hidden = YES;

        mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y);
        
    }
   }
    
   else
   {
       addReviewButton.hidden = YES;
       
       mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y);
       
   }

    

}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}



-(void) addButtonsInNavigationbar
{
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"barstar_logo_gold-320.png"];
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




-(void)handleAddReviewButtonEvent:(id)sender
{
    BOOL isPopOut = NO;
    
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[BarReviewViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            isPopOut = YES;
        }
    }
    if(!isPopOut)
    {
        BarReviewViewController *reviewVc = [[BarReviewViewController alloc]initWithEntity:entity];
        [self.navigationController pushViewController:reviewVc animated:YES];
    
        [reviewVc release];
        
    }
}


-(void)handleDislikeButtonEvent:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [self StartHandle];
    [BarServerAPI API_UpdateVote:self forBarName:titleLabel.text WithFbookName:[prefs objectForKey:@"fbookID"] withVote:@"dis like"];
}

-(void)handleLikeButtonEvent:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self StartHandle];

    [BarServerAPI API_UpdateVote:self forBarName:titleLabel.text WithFbookName:[prefs objectForKey:@"fbookID"] withVote:@"like"];
}

-(void)handleUndoButtonEvent:(id)sender
{
       NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self StartHandle];

    [BarServerAPI API_UndoVote:self forBarName:titleLabel.text WithFbookName:[prefs objectForKey:@"fbookID"]];
}
-(void)handleSearchButtonEvent:(id)sender
{
    BOOL isPopOut = NO;
    
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[BarSearchViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            isPopOut = YES;
        }
    }
    if(!isPopOut)
    {
        BarSearchViewController *mapVc = [[BarSearchViewController alloc]init];
        [self.navigationController pushViewController:mapVc animated:YES];
        [mapVc release];
    }
}
-(void)handleCameraButtonEvent:(id)sender
{
    BarMapViewController *mapVc = [[BarMapViewController alloc]init];
    [self.navigationController pushViewController:mapVc animated:YES];
    [mapVc release];
    
}
-(void)handleRefreshButtonEvent:(id)sender
{
    BOOL isPopOut = NO;
    
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[BarListViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            isPopOut = YES;
        }
    }
    if(!isPopOut)
    {
        BarListViewController *reviewVc = [[BarListViewController alloc]init];
        [self.navigationController pushViewController:reviewVc animated:YES];
        
        [reviewVc release];
        
    }

    
}

-(NSString *) convertDateFormat:(NSString *)dateStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Calgary/Canada"]];
    NSDate * convertedDate  = [formatter dateFromString:dateStr];
    formatter.dateFormat = @"dd MMM, hh:mm a";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Calgary/Canada"]];
    
    NSString *convertedStr = [formatter stringFromDate:convertedDate];
    if(convertedStr == nil)
    {
        return dateStr;
        
    }
    return convertedStr;
    
    
    
}
//////lekshmi
-(float) returnHeightBAsedOnTextForTextWithSize:(CGSize)size withText:(NSString *)text
{
    CGSize maximumLabelSize = CGSizeMake(size.width - 50, FLT_MAX);
    
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeCharacterWrap];
    
    //adjust the label the the new height.
    size.height = expectedLabelSize.height;
    
    return size.height;
    
    
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



#pragma mark - Server api 

-(void)API_CALLBACK_BarImages:(NSArray *)data
{
    NSLog(@"data %@",data);
    
//    NSMutableArray *imagesArray = [[NSMutableArray alloc]init];
//    
//    for (int i = 0; i  < [data count]; i ++)
//    {
//        NSDictionary *dict = [data objectAtIndex:i];
//        NSString *photoId = [dict objectForKey:@"IdPhoto"];
//        [imagesArray addObject:photoId];
//        
//    }
    imagesIdArray = [[NSArray alloc]initWithArray:data];
    
    
    [imagesView setImagesForScrollView:data];
    
    
}
-(void)API_CALLBACK_OerAllVotes:(NSMutableArray *)data
{
    NSLog(@"over all votes %@",data);
    for(int i = 0 ; i < [data count];i ++)
    {
        NSDictionary* votes  = [data objectAtIndex:i];
        
        id value = [votes objectForKey:@"likes"];
        
        if ([value isKindOfClass: [NSNull class]])
        {
            percentageLabel.text = @"0 %";
            likeButton.enabled = YES;
            dislikeButton.enabled = YES;
            undoButton.hidden = YES;
             overallVotesView.text = [NSString stringWithFormat:@"0 people voted"];
        }
        else
        {
            //added by bharathi
            id alreadyVoted = [votes objectForKey:@"alreadyvoted"];
            int iAmVoted = 0;
            if([alreadyVoted isKindOfClass: [NSNull class]])
            {
                iAmVoted = 0;
                likeButton.enabled = YES;
                dislikeButton.enabled = YES;
                undoButton.hidden = YES;
            }
            
            else
            {
                NSString *alreadyVoteStr = [votes objectForKey:@"alreadyvoted"];
                if([alreadyVoteStr intValue]> 0)
                {
                    iAmVoted = 1;
                    likeButton.enabled = NO;
                    dislikeButton.enabled = NO;
                    undoButton.hidden = NO;
                    
                }
                else{
                    iAmVoted = 0;
                    likeButton.enabled = YES;
                    dislikeButton.enabled = YES;
                    undoButton.hidden = YES;
                }
                
            }

            
            NSString *likesString = [votes objectForKey:@"likes"];
            
           NSString *totalvotesString = [votes objectForKey:@"totalvotes"];
              overallVotesView.text = [NSString stringWithFormat:@"%@ people voted",totalvotesString];
            
            float likesInt = likesString.floatValue;
            float totalvotesInt = totalvotesString.floatValue;
            
            float division = likesInt / totalvotesInt;
            int final = division * 100;
            percentageLabel.text = [NSString stringWithFormat:@"%i %%", final];
            
        }
        
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [BarServerAPI API_UpdatePercentage:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"] withPercentage:percentageLabel.text];
    
    
    [self EndHandle];

    undoButton.titleLabel.textColor = [UIColor blackColor];
    likeButton.titleLabel.textColor = [UIColor blackColor];
    dislikeButton.titleLabel.textColor = [UIColor blackColor];
}

-(void)API_CALLBACK_UpdatePercentage:(NSArray *)data
{
    NSLog(@"updatedPercentage %@",data);
    
}
-(void)API_CALLBACK_UpdateVotes:(NSArray *)data
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self StartHandle];

    [BarServerAPI API_GetOverAllVotes:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"]];
  

    NSLog(@"update vote %@",data);
    likeButton.enabled = NO;
    dislikeButton.enabled = NO;
    undoButton.hidden = NO;
    
    undoButton.titleLabel.textColor = [UIColor blackColor];
    likeButton.titleLabel.textColor = [UIColor blackColor];
    dislikeButton.titleLabel.textColor = [UIColor blackColor];

    
}
-(void)API_CALLBACK_UndoVotes:(NSArray *)data
{

    [self StartHandle];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [BarServerAPI API_GetOverAllVotes:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"]];


    likeButton.enabled = YES;
    dislikeButton.enabled = YES;
    undoButton.hidden = YES;
    
    undoButton.titleLabel.textColor = [UIColor blackColor];
    likeButton.titleLabel.textColor = [UIColor blackColor];
    dislikeButton.titleLabel.textColor = [UIColor blackColor];

    

    
}
-(void)API_CALLBACK_ReviewDetails:(NSArray *)reviewArray
{
    [self EndHandle];

    
    for(UIView *sviews in reviewsScrollView.subviews)
    {
        [sviews removeFromSuperview];
        
    }
    int originY = 0;
    for(int i = 0 ; i < [reviewArray count]; i ++)
    {
        NSDictionary *dict = [reviewArray objectAtIndex:i];
        NSString *reviewText = [dict objectForKey:@"review"];
        
        
        [reviewText stringByReplacingOccurrencesOfString:@"''" withString:@"'"];
        
        float maxHeight = [self returnHeightBAsedOnTextForTextWithSize:reviewsScrollView.frame.size withText:reviewText];
        
        
        UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, reviewsScrollView.frame.size.width, maxHeight + 45)];
        
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200,25)];
        nameLabel.text = [NSString stringWithFormat:@"Posted By : %@",[dict objectForKey:@"fbookName"]];
    
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.backgroundColor =  [UIColor clearColor];
        
        [tempView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 270,maxHeight)];
        reviewLabel.text = reviewText;
        reviewLabel.numberOfLines = 0;
        reviewLabel.textAlignment = NSTextAlignmentLeft;
        reviewLabel.font = [UIFont systemFontOfSize:14];
        reviewLabel.backgroundColor = [UIColor clearColor];
        
        [tempView addSubview:reviewLabel];
        [reviewLabel release];
        
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 190,15)];
        dateLabel.text = [NSString stringWithFormat:@"%@",[self convertDateFormat:[dict objectForKey:@"dateTime"]]];
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.backgroundColor = [UIColor clearColor];
        
        [tempView addSubview:dateLabel];
        [dateLabel release];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, tempView.frame.size.height - 2 , tempView.frame.size.width-10, 1)];
        
        lineLabel.backgroundColor = [UIColor darkGrayColor];
        
        [tempView addSubview:lineLabel];
        
        
        [reviewsScrollView addSubview:tempView];
        
      
        
        [tempView release];
        
        
        originY = originY + maxHeight + 50;
        
        reviewsScrollView.contentSize = CGSizeMake(reviewsScrollView.frame.size.width, originY + 11);
        if([reviewArray count] == 1)
        {
            CGRect scrollRect =  reviewsScrollView.frame;
            scrollRect.size.height = MIN(tempView.frame.size.height, reviewsScrollView.frame.size.height);
            
            reviewsScrollView.frame = scrollRect;
            
            scrollRect =  reviewsView.frame;
            scrollRect.size.height = reviewsScrollView.frame.size.height + 30;
            
            reviewsView.frame = scrollRect;
            reviewsScrollView.hidden = NO;
            
            
            scrollRect =  addReviewButton.frame;
            scrollRect.origin.y = reviewsView.frame.origin.y + reviewsView.frame.size.height + 10;
            
            addReviewButton.frame = scrollRect;
            
            
            mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y + 50);

            
        }

        

        }
    
    if([reviewArray count] == 0)
    {
        CGRect scrollRect =  reviewsView.frame;
        scrollRect.size.height = 30;
        
        reviewsView.frame = scrollRect;
        reviewsScrollView.hidden  =YES;
        
        scrollRect =  addReviewButton.frame;
        scrollRect.origin.y = reviewsView.frame.origin.y + reviewsView.frame.size.height + 10;
        
        addReviewButton.frame = scrollRect;
        
        mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, addReviewButton.frame.size.height + addReviewButton.frame.origin.y + 50);

        
       
    }
    
    
}
-(void)API_CALLBACK_ServerError:(NSString *)error
{
    [self EndHandle];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didImageTapped:(id)sender
{
    if([imagesIdArray count] > 0)
    {
        BarViewPhotoViewController *viewVc = [[BarViewPhotoViewController alloc]initWithEntity:entity];
        [self.navigationController pushViewController:viewVc animated:YES];
        [viewVc setImagesForScrollView:imagesIdArray];
        [viewVc release];
        
    }
}

@end
