//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarViewPhotoViewController.h"
#import "BarUtility.h"
#import "BarMenuViewController.h"

@interface BarViewPhotoViewController ()

@end

@implementation BarViewPhotoViewController

- (id)initWithEntity:(StreamEntity *)entity
{
    self = [super init];
    if (self)
    {
        streamEntity = entity;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControl];
    [self addButtonsInNavigationbar];
    
	// Do any additional setup after loading the view.
}

-(void)dealloc
{
   
    if(imagesScroll)
    {
        [imagesScroll release];
    }
    if(mainView)
    {
        [mainView release];
    }
    [super dealloc];
    
}

-(void) initControl
{
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
    
    imagesScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height -45)];
    imagesScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back3.png"]];
//    imagesScroll.layer.cornerRadius = 10;
//    imagesScroll.layer.borderColor = [UIColor clearColor].CGColor;
//    imagesScroll.layer.borderWidth  = 1;
    imagesScroll.showsHorizontalScrollIndicator=YES;
    imagesScroll.showsVerticalScrollIndicator=YES;
    imagesScroll.pagingEnabled = YES;
    [imagesScroll setScrollEnabled:YES];
    [mainView addSubview:imagesScroll];
    mainView.userInteractionEnabled = YES;
    

    
    
   
    
    
    
    
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

-(void) createImgesInScrollWithIndex:(int)index
{
    int x = 0 ;
    int tag = 1000;
    for (int i = 1 ; i <= index; i++)
    {
        
        UIImageView *iamgeButton = [[UIImageView alloc]init];
        
        iamgeButton.frame = CGRectMake(x, 0, imagesScroll.frame.size.width, imagesScroll.frame.size.height);
        iamgeButton.tag = tag + i;

        iamgeButton.userInteractionEnabled = NO;
        [imagesScroll addSubview:iamgeButton];

        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(x + 20, imagesScroll.frame.size.height - 120, imagesScroll.frame.size.width - 40, 100)];
        
        [imagesScroll addSubview:titleView];
        titleView.alpha = 0.7;
        titleView.backgroundColor = [UIColor blackColor];

        titleView.layer.cornerRadius = 20;
        titleView.layer.borderColor = UIColorFromRGB(0x4979B3).CGColor;
        titleView.layer.borderWidth = 2;
        
        
       UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5,titleView.frame.size.width-40, 20)];
        [titleView addSubview:titleLabel];
        
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.frame.size.height + titleLabel.frame.origin.y , titleView.frame.size.width -40, 20)];
        [titleView addSubview:addressLabel];
        titleLabel.backgroundColor  = [UIColor clearColor];
        addressLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = UIColorFromRGB(0xE8B619);
        addressLabel.textColor =[UIColor whiteColor];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textAlignment = NSTextAlignmentCenter;

        addressLabel.font = [UIFont boldSystemFontOfSize:15];
        
        titleLabel.tag = 100+ i + tag;
        addressLabel.tag = 300 + tag + i;
        
        titleLabel.text = streamEntity.barTitle;
        addressLabel.text = streamEntity.address;

        
        [titleLabel release];
        [addressLabel release];
        
        UILabel *  dateLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(70, 10, 100, 30)];
        dateLabel.frame = CGRectMake(20,  addressLabel.frame.size.height + addressLabel.frame.origin.y,  titleView.frame.size.width -40, 20);
        dateLabel.text = @"";
        dateLabel.textAlignment=UITextAlignmentCenter;
        dateLabel.textColor=[UIColor whiteColor];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.font=[UIFont boldSystemFontOfSize:14];
        [titleView addSubview:dateLabel];
        dateLabel.tag = tag + 400 + i;
        
        dateLabel.text = @"";
        
        [dateLabel release];
        

        
        
        UILabel *  postLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(70, 10, 100, 30)];
        postLabel.frame = CGRectMake(20,  dateLabel.frame.size.height + dateLabel.frame.origin.y,  titleView.frame.size.width -40, 20);
        postLabel.text = @"";
        postLabel.textAlignment=UITextAlignmentCenter;
        postLabel.textColor=[UIColor whiteColor];
        postLabel.backgroundColor=[UIColor clearColor];
        postLabel.font=[UIFont boldSystemFontOfSize:14];
        [titleView addSubview:postLabel];
        postLabel.tag = tag + 200 + i;
        
        postLabel.text = @"Loading Image...";
        
        [postLabel release];
        
        
        
        x = x +  imagesScroll.frame.size.width;
    }
    imagesScroll.contentSize = CGSizeMake(x, imagesScroll.frame.size.height);
    
}

-(void) setImagesForScrollView:(NSArray *)iamgesidArray
{
    
    
    
    [self createImgesInScrollWithIndex:[iamgesidArray count]];
    
    for(int i = 0 ; i < [iamgesidArray count]; i++)
    {
        NSDictionary *dict = [iamgesidArray objectAtIndex:i];
        NSString *photoId = [dict objectForKey:@"IdPhoto"];
        NSString *time = [dict objectForKey:@"dataLabel"];
        NSString *author = [dict objectForKey:@"postedBy"];
        
        [self downloadImages:photoId forIndex:i+1 withTime:time withAuthor:author];
        
    }
    
    
}

int totalThread = 0;
-(void) downloadImages:(NSString *)photoId forIndex:(int) index withTime:(NSString *)dateTime withAuthor:(NSString *)author

{
    [self StartHandle];

    
    int IdPhoto = [photoId intValue];
    NSURL* imageURL = [BarServerAPI urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:NO];
    
    
    AFImageRequestOperation* imageOperation =
//    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
//                                                      success:^(UIImage *image)
    [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:imageURL] imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //create an image view, add it to the view

        
        int buttonTag = 1000 + index;
        
        UIImageView * button = (UIImageView *)[imagesScroll viewWithTag:buttonTag];
        
        [button setImage:image];
        
        UILabel * authLabel = (UILabel *)[imagesScroll viewWithTag:(1000+200+index)];
        authLabel.text = [NSString stringWithFormat:@"Posted By: %@", author];
        
        UILabel * datelabel = (UILabel *)[imagesScroll viewWithTag:(1000+400+index)];
        datelabel.text = dateTime;

        [self EndHandle];
        
        

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        totalThread --;

        if(totalThread == 0)
        {
            [self EndHandle];
        }
        

    }
    ];

    

    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    totalThread ++;
    [queue addOperation:imageOperation];
    NSLog(@"total Thread = %d",totalThread);

    
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



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
