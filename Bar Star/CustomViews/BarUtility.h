//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>

@interface BarUtility : NSObject

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
//#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define IS_IPHONE_5 (IS_HEIGHT_GTE_568 )

#define NO_SCREEN 0
#define HOME_SCREEN 1
#define DETAIL_SCREEN 2
#define REVIEW_SCREEN 3
#define PHOTO_SCREEN 4
#define ADD_BAR_SCREEN 5
#define SEARCH_SCREEN 6
#define FULL_VIEW_PHOTO_SCREEN 7
#define MENU_SCREEN 8

#define IPHONE_4 1
#define IPHONE_5 2


#define kFacebookAppId @"178346285662602"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

+(void) InitializeScreen;

+ (NSInteger) SCREEN_TYPE;

+ (float) SCREEN_WIDTH;

+ (float) SCREEN_HEIGHT;

////////SPLASH_SCREEN
+(NSString*) SPLASH_SCREEN_BG;

+(NSString *) SPLASH_LOGO_IMAGE;
+(NSString *) SPLASH_LOGIN_LABEL_IMAGE;
+(float) SPLASH_HEADER_IMAGE_HEIGHT;

+(NSString *) SPLASH_HEADER_IMAGE;

+(float) SPLASH_LOGIN_LABEL_ORIGIN_Y;
+(float) SPLASH_LOGIN_BUTTON_ORIGIN_Y;

//List
+(NSString *) LIST_BG_IMAGE;
+(NSString *) LIST_REFRESH_IMAGE;
+(NSString *) LIST_CAMERA_IMAGE;
+(NSString *) LIST_SEARCH_IMAGE;

//List cell
+(NSString *) LIST_CELL_BG_IMAGE;
+(NSString *) LIST_CELL_BAR_IMAGE;

//Detail
+(float) DETAIL_IMAGEVIEW_HEIGHT;
+(NSString *) DETAIL_UNDO_BUTTON_IMAGE;
+(NSString *) DETAIL_LIKE_BUTTON_IMAGE;
+(NSString *) DETAIL_DISLIKE_BUTTON_IMAGE;
+(NSString *) DETAIL_ADD_REVIEW_BUTTON_IMAGE;
+(NSString *) MENU_BUTTON_IMAGE;
@end
