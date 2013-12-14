//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import "BarUtility.h"
#import "BarServerAPI.h"
#import "HandleProcess.h"
#import <FacebookSDK/FacebookSDK.h>


@interface BarSplashViewController : UIViewController<ServerAPIViewDelegate,FBLoginViewDelegate>
{
    BOOL isLogginFirstTime;
    HandleProcess *handleProcess;
}
@property(nonatomic,retain) NSString *fbookId;

@property(nonatomic,retain) UIImageView *mainView;
@property(nonatomic,retain ) UIImageView *headerImage;
@property(nonatomic,retain) UILabel *loginLabel;
@property(nonatomic,retain) UIImageView *logoImageView;

@end
