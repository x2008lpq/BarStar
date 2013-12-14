//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarImagesView.h"
#import "BarServerAPI.h"
#import "AFImageRequestOperation.h"
#import "BarUtility.h"

@implementation BarImagesView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initControls];
        
    }
    return self;
}
-(void)dealloc
{
    if(titleLabel)
    {
        [titleLabel release];
        
    }
    if(imagesScroll)
    {
        [imagesScroll release];
    }
    [super dealloc];
}

-(void) initControls
{
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
    mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greyback.png"]];
    
    [self addSubview:mainView];
    
    mainView.layer.cornerRadius = 10;
    mainView.layer.borderColor = [UIColor clearColor].CGColor;
    mainView.layer.borderWidth  = 1;
    

    imagesScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 30, self.frame.size.width - 40, self.frame.size.height - 40)];
    imagesScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back3.png"]];
    imagesScroll.layer.cornerRadius = 10;
    imagesScroll.layer.borderColor = [UIColor clearColor].CGColor;
    imagesScroll.layer.borderWidth  = 1;
    imagesScroll.showsHorizontalScrollIndicator=YES;
    imagesScroll.showsVerticalScrollIndicator=YES;
    imagesScroll.pagingEnabled = YES;
    [imagesScroll setScrollEnabled:YES];
    [mainView addSubview:imagesScroll];
    
    leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    leftArrow.frame = CGRectMake(10, 10, 39, 19);
    [leftArrow setImage:[UIImage imageNamed:@"arrowtime2.png"] forState:UIControlStateNormal];
    
    [mainView addSubview:leftArrow];
    
    
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(leftArrow.frame.size.width + leftArrow.frame.origin.x, 10, 180, 20)];
    titleLabel.text=@"LIVE PHOTO FEED";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0xE8B619);
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [mainView addSubview:titleLabel];
   
    rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    rightArrow.frame = CGRectMake(mainView.frame.size.width - 50, 10, 39, 19);
    [rightArrow setImage:[UIImage imageNamed:@"arrowtime.png"] forState:UIControlStateNormal];
    
    
    [mainView addSubview:rightArrow];
    mainView.userInteractionEnabled = YES;
}

-(void) createImgesInScrollWithIndex:(int)index
{
    
    for(UIView *subview in imagesScroll.subviews)
    {
        [subview removeFromSuperview];
    }
    int x = 10 ;
    int tag = 1000;
    for (int i = 1 ; i <= index; i++) {
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, imagesScroll.frame.size.width - 20, imagesScroll.frame.size.height - 20)];
        imageView.tag = tag + 300+ i;
        
        [imagesScroll addSubview:imageView];
        
        UIButton *iamgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        iamgeButton.frame = CGRectMake(x, 10, imagesScroll.frame.size.width - 20, imagesScroll.frame.size.height - 20);
        [iamgeButton addTarget:self action:@selector(didImageSelected:) forControlEvents:UIControlEventTouchUpInside];
        iamgeButton.tag = tag + i;
        
        [imagesScroll addSubview:iamgeButton];
       
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 23;
        
        
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
        
        imageView.layer.borderWidth = 1;
        
        imageView.clipsToBounds = YES;

        
        
        UILabel *dateTimeLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(70, 10, 100, 30)];
        dateTimeLabel.frame = CGRectMake(0, iamgeButton.frame.size.height - 50, iamgeButton.frame.size.width, 20);
//        dateTimeLabel.atext=dateOfGame;
        dateTimeLabel.textAlignment=UITextAlignmentCenter;
        dateTimeLabel.textColor=[UIColor whiteColor];
        dateTimeLabel.backgroundColor=[UIColor clearColor];
        dateTimeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [iamgeButton addSubview:dateTimeLabel];
        dateTimeLabel.tag = tag + 100+ i;
        dateTimeLabel.text = @"";
        dateTimeLabel.alpha = 0.7;
        [dateTimeLabel release];
        
      
      UILabel *  postLabel=[[UILabel alloc] init];//WithFrame:CGRectMake(70, 10, 100, 30)];
        postLabel.frame = CGRectMake(0,  iamgeButton.frame.size.height - 30, iamgeButton.frame.size.width, 20);
        postLabel.text=@"Loading..";
        postLabel.textAlignment=UITextAlignmentCenter;
        postLabel.textColor=[UIColor whiteColor];
        postLabel.backgroundColor=[UIColor blackColor];
        postLabel.font=[UIFont boldSystemFontOfSize:14];
        [iamgeButton addSubview:postLabel];
        postLabel.tag = tag + 200 + i;
        postLabel.alpha = 0.7;
        [postLabel release];
        
        x = x +  imagesScroll.frame.size.width;
    }
    imagesScroll.contentSize = CGSizeMake(x, imagesScroll.frame.size.height);
    
}

-(void) didImageSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [delegate didImageTapped:button];
    
    
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
-(void) downloadImages:(NSString *)photoId forIndex:(int) index withTime:(NSString *)dateTime withAuthor:(NSString *)author
{
    int IdPhoto = [photoId intValue];
    NSURL* imageURL = [BarServerAPI urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:YES];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                    success:^(UIImage *image)
     {
         //create an image view, add it to the view
         
         int buttonTag = 1000 + index + 300;
         
         
         UIImageView * button = (UIImageView *)[imagesScroll viewWithTag:buttonTag];
         
        
         [button setImage:image];
         
         
         
         UILabel * dateLabel = (UILabel *)[imagesScroll viewWithTag:(1000+100+index)];
         dateLabel.text  = dateTime;
         
         
         UILabel * authLabel = (UILabel *)[imagesScroll viewWithTag:(1000+200+index)];
         authLabel.text = [NSString stringWithFormat:@"Posted By: %@", author];
         dateLabel.backgroundColor = [UIColor blackColor];
         authLabel.backgroundColor = [UIColor blackColor];
         
         
         
     }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
