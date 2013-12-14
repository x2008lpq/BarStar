//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import "BarServerAPI.h"
#import "HandleProcess.h"
#import <QuartzCore/QuartzCore.h>

@interface BarReviewViewController : UIViewController<UITextViewDelegate,ServerAPIViewDelegate>
{
    UIImageView *mainView;
    UILabel * titleLabel;
    UILabel *addressLabel;
    
    UILabel *maxLabel;
    UIView *reviewsView;
    UIButton *postReviewButton;
    
    UITextView *reviewTextView;
    
    HandleProcess *handleProcess;

}

@property(nonatomic,retain) StreamEntity *entity;

- (id)initWithEntity:(StreamEntity *)entity;
@end
