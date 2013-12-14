//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarReviewViewController.h"
#import "BarUtility.h"

@interface BarReviewViewController ()

@end

@implementation BarReviewViewController

@synthesize entity;

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
    if(mainView)
    {
        [mainView release];
    }
    if(titleLabel)
    {
        [titleLabel release];
    }
    if(addressLabel)
    {
        [addressLabel release];
    }
    if(reviewsView)
    {
        [reviewsView release];
    }
    if(reviewTextView )
    {
        [reviewTextView release];
    }
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
    int posY = 5;
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
    int posX = 0;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 25)];
    [mainView addSubview:titleLabel];
    
    posY = posY + titleLabel.frame.size.height;
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 25)];
    [mainView addSubview:addressLabel];
    titleLabel.backgroundColor  = [UIColor clearColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0xE8B619);
    addressLabel.textColor = UIColorFromRGB(0x919395);
    
    posY = posY + addressLabel.frame.size.height + 5;
    
    reviewsView = [[UIView alloc]initWithFrame:CGRectMake(10, posY, [BarUtility SCREEN_WIDTH]-20, 120)];
    
    reviewsView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:reviewsView];

    reviewTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, reviewsView.frame.size.width - 10, reviewsView.frame.size.height - 10)];
    reviewTextView.delegate = self;
    reviewTextView.font = [UIFont systemFontOfSize:15];
    
    reviewTextView.keyboardType = UIKeyboardTypeDefault;
    reviewTextView.returnKeyType = UIReturnKeyDone;
    
    reviewsView.layer.cornerRadius = 10;
    reviewsView.layer.borderColor = [UIColor clearColor].CGColor;
    reviewsView.layer.borderWidth = 1;
    
    [reviewsView addSubview:reviewTextView];
    
      posY = posY + reviewsView.frame.size.height + 5;
    posX =  [BarUtility SCREEN_WIDTH] - 100;
    maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 15)];
    [mainView addSubview:maxLabel];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.backgroundColor  =[UIColor clearColor];
    maxLabel.font = [UIFont systemFontOfSize:14];
    
    maxLabel.textColor = [UIColor whiteColor];
    
    maxLabel.text =@"140 max";
    
    posY = posY + maxLabel.frame.size.height ;
    
    postReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postReviewButton.frame = CGRectMake(mainView.frame.size.width/2 - 73/2,posY, 73, 34);
    [postReviewButton setTitle:@"Post" forState:UIControlStateNormal];
    
    [postReviewButton addTarget:self action:@selector(handlePostReviewButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    postReviewButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [postReviewButton setBackgroundImage:[UIImage imageNamed:[BarUtility DETAIL_LIKE_BUTTON_IMAGE
                                                              ]] forState:UIControlStateNormal];
    
    [postReviewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [postReviewButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [mainView addSubview:postReviewButton];

    mainView.userInteractionEnabled = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = entity.barTitle;
    addressLabel.text = entity.address;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    addressLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    
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

-(void)handlePostReviewButtonEvent:(id)sender
{
    
  NSString *textStr  = [reviewTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      int len = textStr.length;
    int buck40 = 140;
    int diffbetween = buck40 - len;
    
    
    
    if (diffbetween <= -1){
        
        [[[UIAlertView alloc]initWithTitle:@"Whoa!"
                                   message:@"Keep it to 140"
                                  delegate:nil
                         cancelButtonTitle:@"Close"
                         otherButtonTitles: nil] show];}
    
    
    
    else{
        
        
        if(len == 0){
            
            [[[UIAlertView alloc]initWithTitle:@"Nothing?"
                                       message:@"Tell us what's happening."
                                      delegate:nil
                             cancelButtonTitle:@"Close"
                             otherButtonTitles: nil] show];
            
        }
        
        else{
            [self StartHandle];

            NSDate *now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Calgary/Canada"]];
            NSString *dateTIme = [formatter stringFromDate:now];
            
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *myName = [prefs objectForKey:@"userName"];

            
            [BarServerAPI Initialize];
            [textStr stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            
            [BarServerAPI API_PostReviews:self forBarName:entity.barTitle withReview:reviewTextView.text WithTime:dateTIme withfbName:myName];
            
            //call service to update reviews
        }
    }
    

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
     
 
    if([BarUtility SCREEN_TYPE] == IPHONE_4)
    {
    reviewsView.frame = CGRectMake(10, addressLabel.frame.size.height + addressLabel.frame.origin.y, [BarUtility SCREEN_WIDTH]-20, 100);
    reviewTextView .frame = CGRectMake(5, 5, reviewsView.frame.size.width - 10, reviewsView.frame.size.height - 10);
    int posY = reviewsView.frame.size.height + reviewsView.frame.origin.y+ 5;
   int  posX =  [BarUtility SCREEN_WIDTH] - 100;
    maxLabel.frame = CGRectMake(posX, posY, [BarUtility SCREEN_WIDTH] - posX, 15);
    posY = posY + 5;
    
    postReviewButton.frame = CGRectMake(mainView.frame.size.width/2 - 73/2,posY, 73, 34);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
}
-(void)textViewDidChange:(UITextView *)textView {
    // count down the text when entered
    int len = reviewTextView.text.length;
    int buck40 = 140;
    int diffbetween = buck40 - len;
    
    maxLabel.text = [NSString stringWithFormat:@"%d max", diffbetween];
    
    if (diffbetween <= -1){
        
        
        maxLabel.textColor = [UIColor redColor];
        
    }
    
    if (diffbetween >= 0){
        
        maxLabel.textColor = [UIColor whiteColor];
    }
    
    
}


-(void)API_CALLBACK_PostReviewResponse:(NSArray *)responseArray
{
    
    [self EndHandle];
    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Awesome!"
                               message:@"Review Posted!"
                              delegate:nil
                     cancelButtonTitle:@"close"
                     otherButtonTitles: nil];
    [Alert show];
    [Alert release];
    

    
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
