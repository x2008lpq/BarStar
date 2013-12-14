//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Twitter/Twitter.h"
#import "Facebook.h"
@interface BarMenuViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBLoginViewDelegate,FBSessionDelegate,FBDialogDelegate>
{
    UIImageView *mainView;
    UIButton *findBarButton;
    UIButton *snapPhotoButton;
    UIButton *feedbackButton;
    UIButton *shareButton;
    UIImageView * shareSubView;
}
@property(nonatomic,retain) Facebook *facebook;

@end
