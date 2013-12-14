//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarUtility.h"

@implementation BarUtility

static NSInteger SCREEN_TYPE;

static float SCREEN_WIDTH;

static float SCREEN_HEIGHT;


+(void) InitializeScreen
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    SCREEN_WIDTH = screenRect.size.width;
    
    SCREEN_HEIGHT = screenRect.size.height;
    NSLog(@"Width - %f, SCREEN_HEIGHT - %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    if (screenRect.size.height <= 480.0)
    {
        SCREEN_TYPE = IPHONE_4;
    }
    else if (screenRect.size.height > 480.0)
    {
        SCREEN_TYPE = IPHONE_5;
    }
    
    NSLog(@"%d",SCREEN_TYPE);
}

+ (NSInteger)SCREEN_TYPE {
    return SCREEN_TYPE;
}

+ (float)SCREEN_WIDTH {
    return SCREEN_WIDTH;
}

+ (float)SCREEN_HEIGHT {
    return SCREEN_HEIGHT;
}

+(NSString*) SPLASH_SCREEN_BG {
    if(SCREEN_TYPE==IPHONE_4)
        return @"firstScreen4.png";
    else if(SCREEN_TYPE==IPHONE_5)
        return @"offback.png";
    else
        return @"offback.png";
}

+(float) SPLASH_HEADER_IMAGE_HEIGHT
{
    return 162/2;
}

+(NSString *) SPLASH_HEADER_IMAGE
{
    return @"frontlogo.png";
}
+(NSString *) SPLASH_LOGO_IMAGE
{
    return @"NLlogo.png";
}
+(NSString *) SPLASH_LOGIN_LABEL_IMAGE
{
    return @"banner2.png";
}


+(float) SPLASH_LOGIN_BUTTON_ORIGIN_Y
{
    if(SCREEN_TYPE==IPHONE_4)
        return 250;
    else if(SCREEN_TYPE==IPHONE_5)
        return 300;
    else
        return 250;

}

+(float) SPLASH_LOGIN_LABEL_ORIGIN_Y
{
    return (SCREEN_HEIGHT - 140);
    
}

///List screen
+(NSString *) LIST_BG_IMAGE
{
    return @"back3.png";
}

+(NSString *) LIST_REFRESH_IMAGE
{
    return @"starbutt2.png";
}
+(NSString *) LIST_CAMERA_IMAGE
{
    return @"photobutt.png";
}
+(NSString *) LIST_SEARCH_IMAGE
{
    return @"searchbutt.png";
}
// List Cell

+(NSString *) LIST_CELL_BG_IMAGE
{
    return @"greyback.png";
}
+(NSString *) LIST_CELL_BAR_IMAGE
{
    return @"back3.png";
}

//Detail Screen
+(float) DETAIL_IMAGEVIEW_HEIGHT
{
    return 263;
    
}
+(NSString *) DETAIL_UNDO_BUTTON_IMAGE
{
    return @"likeyellow.png";
}
+(NSString *) DETAIL_LIKE_BUTTON_IMAGE
{
    return @"likeyellow.png";
}
+(NSString *) DETAIL_DISLIKE_BUTTON_IMAGE
{
    return @"nolikegrey.png";
}

+(NSString *) DETAIL_ADD_REVIEW_BUTTON_IMAGE
{
    return @"nolikegrey.png";
}
+(NSString *) MENU_BUTTON_IMAGE
{
    return @"likeyellow.png";
}

@end
