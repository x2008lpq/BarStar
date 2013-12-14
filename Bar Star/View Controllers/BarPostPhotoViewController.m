//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarPostPhotoViewController.h"
#import "BarUtility.h"
#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"
#import "BarListViewController.h"
#import "BarMenuViewController.h"

@interface BarPostPhotoViewController ()

@end

@implementation BarPostPhotoViewController

@synthesize imageRot,addressLabel,barNameLabel,locationManager,percentage;

- (id)initWithMapItem:(MKMapItem *)mapItem
{
    self = [super init];
    if (self) {
        currentMapItem = mapItem;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
    [self takePhoto];
    [self addButtonsInNavigationbar];
    self.navigationItem.hidesBackButton = YES;
    
	// Do any additional setup after loading the view.
}


-(void)dealloc
{
    
   [mainView release];
    
  [handleProcess release];
    
 [titleView release];
    [titleLabel release];
    [addressLabel release];
   [mainImageView release];
  
    
    [super dealloc];
    
}
-(void) initControls
{
    mainView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [BarUtility SCREEN_WIDTH], [BarUtility SCREEN_HEIGHT])];
    [mainView setImage:[UIImage imageNamed:[BarUtility LIST_BG_IMAGE]]];
    [self.view addSubview:mainView];
    
        
    
    postPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *postImage = [UIImage imageNamed:[BarUtility DETAIL_LIKE_BUTTON_IMAGE]];
    [postPhotoButton addTarget:self action:@selector(handlePostPhotoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    postPhotoButton.frame = CGRectMake(mainView.frame.size.width/2 - 106/2,mainView.frame.size.height - 100, 131, 33);
    [postPhotoButton setTitle:@"Post Photo!" forState:UIControlStateNormal];

    [postPhotoButton setBackgroundImage:postImage forState:UIControlStateNormal];
    postPhotoButton.titleLabel.textColor = [ UIColor blackColor];
    
    postPhotoButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];

    
    [mainView addSubview:postPhotoButton];

    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, mainView.frame.size.width - 20, 50)];
    [mainView addSubview:titleView];
    titleView.alpha = 0.7;
    titleView.backgroundColor = [UIColor blackColor];
    
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,titleView.frame.size.width, 25)];
    [titleView addSubview:titleLabel];
    
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height, titleView.frame.size.width , 25)];
    [titleView addSubview:addressLabel];
    titleLabel.backgroundColor  = [UIColor clearColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0xE8B619);
    addressLabel.textColor = UIColorFromRGB(0x919395);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *street = currentMapItem.placemark.addressDictionary[@"Street"];
    NSString *location = [NSString stringWithFormat:@"%@", street];
    
    
    titleLabel.text = currentMapItem.name;
    addressLabel.text = location;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    addressLabel.font = [UIFont boldSystemFontOfSize:15];
  
    mainView.userInteractionEnabled = YES;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [BarServerAPI Initialize];
    [BarServerAPI API_GetOverAllVotes:self forBarName:titleLabel.text WithFbookId:[prefs objectForKey:@"fbookID"]];
    
    self.percentage = @"0";
    

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

-(void)API_CALLBACK_OerAllVotes:(NSMutableArray *)data
{
    NSLog(@"over all votes %@",data);
    for(int i = 0 ; i < [data count];i ++)
    {
        NSDictionary* votes  = [data objectAtIndex:i];
        
        id value = [votes objectForKey:@"likes"];
        
        if ([value isKindOfClass: [NSNull class]])
        {
            self.percentage = @"0"; // default set the percentage as 0
        }
        else
        {
            NSString *likesString = [votes objectForKey:@"likes"];
            
            NSString *totalvotesString = [votes objectForKey:@"totalvotes"];
            float likesInt = likesString.floatValue;
            float totalvotesInt = totalvotesString.floatValue;
            
            float division = likesInt / totalvotesInt;
            int final = division * 100;
            self.percentage = [NSString stringWithFormat:@"%i", final];
    
        }
    
    }
}

-(void)API_CALLBACK_ServerError:(NSString *)error
{
    
}


-(void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
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




-(void)handlePostPhotoButtonEvent:(id)sender
{

    [self StartHandle];
    NSString *PicType = @"bar";
    NSString *postLat = [NSString stringWithFormat:@"%.8f", currentMapItem.placemark.coordinate.latitude];
    NSString *postLon = [NSString stringWithFormat:@"%.8f", currentMapItem.placemark.coordinate.longitude];
    
    //added by bharathi
    
    if(postLat.length == 0)
    {
        NSLog(@"postLat votes nil");
        postLat = @" ";
        
    }
    if(postLon.length == 0)
    {
        NSLog(@"postLon votes nil");
        postLon = @" ";
        
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *myName = [prefs objectForKey:@"userName"];

    
    NSDate * now = [NSDate date];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEE, MMM d, yyyy h:mm a"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kMainURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setData: UIImageJPEGRepresentation(mainView.image,0.8) withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    
    [request setPostValue:@"upload" forKey:@"command"];
    
    [request setPostValue:titleLabel.text forKey:@"BarName"];
    [request setPostValue:addressLabel.text forKey:@"Address"];
    [request setPostValue:PicType forKey:@"PicType"];
    [request setPostValue:@"2" forKey:@"IdUser"];
    [request setPostValue:percentage forKey:@"percentage"];
    [request setPostValue:postLat forKey:@"postLat"];
    [request setPostValue:postLon forKey:@"postLon"];
    [request setPostValue:newDateString forKey:@"dataLabel"];
    [request setPostValue:myName forKey:@"postedBy"];
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];//NSISOLatin1StringEncoding
    [request setDelegate:self];
    
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];

    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self EndHandle];
    
    NSData *responseData = [request responseData];
    
    // Store incoming data into a string
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Server response:%@", response);
    
  UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Awesome!"
                               message:@"Your photo is uploaded"
                              delegate:nil
                     cancelButtonTitle:@"close"
                     otherButtonTitles: nil];
    [alert show];
    [alert release];
    
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
        BarListViewController *listVc = [[BarListViewController alloc]init];
        [self.navigationController pushViewController:listVc animated:YES];
        
        [listVc release];
        
    }

    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self EndHandle];
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Bar Star"
                                                    message:@"Your photo is not uploaded. please try again"
                                                   delegate:nil
                                          cancelButtonTitle:@"close"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}



-(void)logout
{
    
}

#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self imagePickerImage:image];
    
    // Resize the image from the camera
UIImage *scaledImage = [imageRot resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(mainView.frame.size.width, mainView.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    // Crop the image to a square (yikes, fancy!)
    
//    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -mainView.frame.size.width)/2, (scaledImage.size.height -mainView.frame.size.height)/2, mainView.frame.size.width, mainView.frame.size.height)];

   
    // Show the photo on the screen
    mainView.image = scaledImage;
    mainView.contentMode = UIViewContentModeScaleAspectFit;
    [picker dismissModalViewControllerAnimated:NO];
}




- (void) imagePickerImage:(UIImage*)image
{
//    if (image.imageOrientation == UIImageOrientationDown)
//    {
//        UIImage* rotatedimage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
//        imageRot = rotatedimage;
//        
//    }
//    else if (image.imageOrientation == UIImageOrientationUp)
//    {
//        UIImage* rotatedimage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
//        imageRot = rotatedimage;
//    }
//    
//    else
    {
        
        imageRot = image;
    }

    
}



- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [picker dismissModalViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
