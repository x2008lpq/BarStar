//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarMenuViewController.h"
#import "BarUtility.h"
#import "SBJSON.h"
#import "BarSearchViewController.h"
#import "BarMapViewController.h"

@interface BarMenuViewController ()

@end

@implementation BarMenuViewController
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    if(mainView)
    {
        [mainView release];
    }
    if(shareSubView)
    {
        [shareSubView release];
        
    }
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self facebookshareaction];
    
    facebook = [[Facebook alloc]initWithAppId:@"404567742994207" andDelegate:self];
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
    
    
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
    int posX = 20;
    int posY = 50;
    

    UIImage *image = [UIImage imageNamed:[BarUtility MENU_BUTTON_IMAGE]];
    
    findBarButton =[UIButton buttonWithType:UIButtonTypeCustom];
    findBarButton.frame = CGRectMake(posX,posY, 280, 44);
    [findBarButton setTitle:@"Find Bar" forState:UIControlStateNormal];
    [findBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [findBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [findBarButton setBackgroundImage:image forState:UIControlStateHighlighted];
    findBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [findBarButton addTarget:self action:@selector(handelBarButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findBarButton];

    
    posY = posY + 60;
    snapPhotoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    snapPhotoButton.frame = CGRectMake(posX,posY, 280, 44);
    [snapPhotoButton setTitle:@"Snap Photo" forState:UIControlStateNormal];
    [snapPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [snapPhotoButton setBackgroundImage:image forState:UIControlStateNormal];
    [snapPhotoButton setBackgroundImage:image forState:UIControlStateHighlighted];
    snapPhotoButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [snapPhotoButton addTarget:self action:@selector(hadlePhotoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:snapPhotoButton];
    posY = posY + 60;

    
    feedbackButton =[UIButton buttonWithType:UIButtonTypeCustom];
    feedbackButton.frame = CGRectMake(posX,posY, 280, 44);
    [feedbackButton setTitle:@"Feedback" forState:UIControlStateNormal];
    [feedbackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedbackButton setBackgroundImage:image forState:UIControlStateNormal];
    [feedbackButton setBackgroundImage:image forState:UIControlStateHighlighted];
    feedbackButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [feedbackButton addTarget:self action:@selector(handleFeedbackButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedbackButton];
    posY = posY + 60;

    shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(posX,posY, 280, 44);
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:image forState:UIControlStateNormal];
    [shareButton setBackgroundImage:image forState:UIControlStateHighlighted];
    shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [shareButton addTarget:self action:@selector(handleShareButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
	// Do any additional setup after loading the view.
}
-(void)handelBarButtonEvent:(id)sender
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
-(void)hadlePhotoButtonEvent:(id)sender
{
    BOOL isPopOut = NO;
    
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[BarMapViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            isPopOut = YES;
        }
    }
    if(!isPopOut)
    {
        BarMapViewController *mapVc = [[BarMapViewController alloc]init];
        [self.navigationController pushViewController:mapVc animated:YES];
        [mapVc release];
    }

    
    
}

-(void)handleShareButtonEvent:(id)sender
{

    
   shareSubView = [[UIImageView alloc] initWithFrame:CGRectMake(10,60,300,300)];
    [shareSubView setImage:[UIImage imageNamed:@"popup.png"]];
    shareSubView.userInteractionEnabled = YES;
    [self.view  addSubview:shareSubView];
    
    
    
    UIImage *fbimage2 = [UIImage imageNamed:@"facebook-normal.png"];
    UIImage *fbimage22 = [UIImage imageNamed:@"facebook-over.png"];
    float fbimage2W = fbimage2.size.width/2;
    float fbimage2H = fbimage2.size.height/2;
    NSInteger y = 40;
    
    UIButton *facebookactionbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    facebookactionbutton .frame=CGRectMake(10, y, fbimage2W,fbimage2H);
    [facebookactionbutton setBackgroundImage:fbimage2 forState:UIControlStateNormal];
    [facebookactionbutton setBackgroundImage:fbimage22 forState:UIControlStateHighlighted];
    [facebookactionbutton addTarget:self action:@selector(facebookshareaction) forControlEvents:UIControlEventTouchUpInside];
    [shareSubView addSubview:facebookactionbutton];
    
    
    
    
    UIImage *twitimage2 = [UIImage imageNamed:@"twitter-normal.png"];
    UIImage *twitimage22 = [UIImage imageNamed:@"twitter-over.png"];
    float twitimage2W = twitimage2.size.width/2;
    float twitimage2H = twitimage2.size.height/2;
    y= y+50;
    
    UIButton *twitteractionbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [twitteractionbutton setFrame:CGRectMake(10, y, twitimage2W,twitimage2H)];
    [twitteractionbutton setBackgroundImage:twitimage2 forState:UIControlStateNormal];
    [twitteractionbutton setBackgroundImage:twitimage22 forState:UIControlStateHighlighted];
    [twitteractionbutton addTarget:self action:@selector(twittershareaction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareSubView addSubview:twitteractionbutton];
    
    
    
    UIImage *emailimage2 = [UIImage imageNamed:@"email-normal.png"];
    UIImage *emailimage22 = [UIImage imageNamed:@"email-over.png"];
    float emailimage2W = emailimage2.size.width/2;
    float emailimage2H = emailimage2.size.height/2;
    y= y+50;
    
    UIButton *emailactionbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [emailactionbutton setFrame:CGRectMake(10, y, emailimage2W,emailimage2H)];
    [emailactionbutton setBackgroundImage:emailimage2 forState:UIControlStateNormal];
    [emailactionbutton setBackgroundImage:emailimage22 forState:UIControlStateHighlighted];
    [emailactionbutton addTarget:self action:@selector(emailshareaction) forControlEvents:UIControlEventTouchUpInside];
    
    [shareSubView addSubview:emailactionbutton];
    
    
    UIImage *smsimage2 = [UIImage imageNamed:@"text-normal.png"];
    UIImage *smsimage22 = [UIImage imageNamed:@"text-over.png"];
    float smsimage2W = smsimage2.size.width/2;
    float smsimage2H = smsimage2.size.height/2;
    
    y= y+50;
    UIButton *smsactionbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [smsactionbutton setFrame:CGRectMake(10, y, smsimage2W,smsimage2H)];
    [smsactionbutton setBackgroundImage:smsimage2 forState:UIControlStateNormal];
    [smsactionbutton setBackgroundImage:smsimage22 forState:UIControlStateHighlighted];
    [smsactionbutton addTarget:self action:@selector(smsshareaction) forControlEvents:UIControlEventTouchUpInside];
    [shareSubView addSubview:smsactionbutton];
    
    UIImage *cancelimage2 = [UIImage imageNamed:@"cancel-normal.png"];
    UIImage *cancelimage22 = [UIImage imageNamed:@"cancel-over.png"];
    float cancelimage2W = cancelimage2.size.width/2;
    float cancelimage2H = cancelimage2.size.height/2;
    y= y+50;
    UIButton *cancelactionbutton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelactionbutton setFrame:CGRectMake(10, y, cancelimage2W,cancelimage2H)];
    [cancelactionbutton setBackgroundImage:cancelimage2 forState:UIControlStateNormal];
    [cancelactionbutton setBackgroundImage:cancelimage22 forState:UIControlStateHighlighted];
    [cancelactionbutton addTarget:self action:@selector(cancelaction) forControlEvents:UIControlEventTouchUpInside];
    [shareSubView addSubview:cancelactionbutton];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)handleFeedbackButtonEvent:(id)sender
{
    
    
    
    NSString *subject = @"Barstar Feedback";
    NSString *mailBody = @"Tell us what you think!";
    // NSString *recipients = @"seanaaron100@gmail.com";
    
    /*
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:biranchi@purpletalk.com?cc=biranchi125@gmail.com&subject=Greetings%20from%20Biranchi!&body=Wish%20you%20were%20here!"]];
     */
    // Check that a mail account is available
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        
        [emailController setSubject:subject];
        [emailController setMessageBody:mailBody isHTML:YES];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"barstar@newlineanalytics.com", nil];
        [emailController setToRecipients:toRecipients];
        
        [self presentModalViewController:emailController animated:YES];
        
        
    }
    // Show error if no mail account is active
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
        
    }
    
    /*
     // load the statusviewcontroller
     StatusViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"StatusViewController"];
     [self.navigationController pushViewController:obj animated:YES];
     
     */
}
-(void)cancelaction{
    shareSubView.hidden = YES;
    [shareSubView removeFromSuperview];
    
}

-(void)twittershareaction{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:
         @"Tweeting from BarStar! :)"];
        //
        //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *documentsDirectory = [paths objectAtIndex:0];
        //        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
        //        // NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:directory"];
        //        UIImage *img = [[UIImage alloc]initWithContentsOfFile:getImagePath];
        //        [tweetSheet addImage:img];
        
        
        //UIImage *image = [UIImage imageNamed:@"sample.jpg"];
        //[tweetSheet addImage:image];
        
        
        
        // [m_imgPictureBg setImage:img];
        // Adding a URL
        //NSURL *url = [NSURL URLWithString:@"http://google.com"];
        //[tweetSheet addURL:url];
        
        
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure  your device has an internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)smsshareaction{
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        
        controller.body = @"BARSTAR";
        controller.recipients = [NSArray arrayWithObjects:@"", @"", nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
    
    
}
-(void)emailshareaction{
    MFMailComposeViewController *mailmpicker = [[MFMailComposeViewController alloc] init];
    
    mailmpicker.mailComposeDelegate = self;
    
    [mailmpicker setToRecipients:[NSArray
                                  arrayWithObjects:@"email address", nil]];
    
    
    [mailmpicker setSubject:@"Email subject here"];
    
    [mailmpicker setMessageBody:@"Email body here" isHTML:NO];
    [self presentModalViewController:mailmpicker animated:YES];
    
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //    message.hidden = NO;
    switch (result)
    {
        case MessageComposeResultCancelled:
            //            message.text = @"Result: canceled";
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //            message.text = @"Result: sent";
            NSLog(@"Result: sent");
            break;
        case MessageComposeResultFailed:
            //            message.text = @"Result: failed";
            NSLog(@"Result: failed");
            break;
        default:
            //            message.text = @"Result: not sent";
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}
#pragma mark - FBSessionDelegate Methods

-(void)facebookshareaction
{
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
    
    if ([facebook isSessionValid])
    {
        
        [ facebook authorize:permissions];
    }
    else
    {
    
        facebook = [[Facebook alloc]initWithAppId:@"404567742994207" andDelegate:self];
        
        
        SBJSON *jsonWriter = [SBJSON new];
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Bar Star",@"name",@"http://iphone.maagstudios.com/monuments_128icon.png",@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing via Bar star application", @"caption",
                                       @"http://iphone.maagstudios.com/monuments_128icon.png", @"picture",
                                       actionLinksStr, @"actions",
                                       nil];
        [facebook dialog:@"feed"
               andParams:params
             andDelegate:self];
        

    }
    
    
}

#pragma mark - FBSessionDelegate Methods
//
// * Called when the user has logged in successfully.
// 
- (void)fbDidLogin
{
    NSLog(@"fbdidlogin");
	[self storeAuthData:[  facebook accessToken] expiresAt:[  facebook expirationDate]];
	//[pendingApiCallsController userDidGrantPermission];
	SBJSON *jsonWriter = [SBJSON new];
	// The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Bar Star",@"name",@"http://iphone.maagstudios.com/monuments_128icon.png",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing via Bar star application", @"caption",
                                   @"http://iphone.maagstudios.com/monuments_128icon.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    [ facebook dialog:@"feed"
            andParams:params
          andDelegate:self];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    
	[self storeAuthData:accessToken expiresAt:expiresAt];
}
///**
// * Called when the user canceled the authorization dialog.
// 
-(void)fbDidNotLogin:(BOOL)cancelled
{
    
    
	//[pendingApiCallsController userDidNotGrantPermission];
}
///**
// * Called when the request logout has succeeded.
// *
- (void)fbDidLogout
{
	// pendingApiCallsController = nil;
	// Remove saved authorization information if it exists and it is
	// ok to clear it (logout, session invalid, app unauthorized)
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"FBAccessTokenKey"];
	[defaults removeObjectForKey:@"FBExpirationDateKey"];
	[defaults synchronize];
}
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
	[defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
	[defaults synchronize];
}
///**
// * Called when the session has expired.
// *
- (void)fbSessionInvalidated
{
	UIAlertView *alertView = [[UIAlertView alloc]
							  initWithTitle:@"Auth Exception"
							  message:@"Your session has expired."
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil,
							  nil];
	[alertView show];
	[self fbDidLogout];
}
#pragma mark - FBRequestDelegate Methods
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"received response");
}
- (void)request:(FBRequest *)request didLoad:(id)result
{
    
}
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
	NSLog(@"Err code: %d", [error code]);
}
-(void)FacebookCall:(NSString *)fbCall
{
    NSArray * permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
	if (![ facebook isSessionValid])
	{
        
		[ facebook authorize:permissions];
	}
	else
	{
        
		SBJSON *jsonWriter = [SBJSON new] ;
        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Discover Indian Monuments with Tamarind Tots",@"name",@"http://iphone.maagstudios.com/monuments_128icon.png",@"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Discover Indian Monuments with Tamarind Tots", @"name",
                                       @"I am loving this new app about famous Indian monuments from Tamarind Tots!It has fun activities,cool facts about each monument,and lots of real life photos.Come join the fun!", @"caption",
                                       @"http://iphone.maagstudios.com/monuments_128icon.png", @"picture",
                                       actionLinksStr, @"actions",
                                       nil];
        [ facebook dialog:@"feed"
                andParams:params
              andDelegate:self];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
