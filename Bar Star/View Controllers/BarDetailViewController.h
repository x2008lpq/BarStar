//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BarImagesView.h"
#import "BarServerAPI.h"
#import "HandleProcess.h"

@interface BarDetailViewController : UIViewController<ServerAPIViewDelegate,DetailImageViewDelegate,MKReverseGeocoderDelegate>
{
    UIImageView *mainView;
    
    UIButton *refreshButton;
    UIButton *cameraButton;
    UIButton *searchButton;
    
    UIScrollView *mainScrollView;
    UILabel * titleLabel;
    UILabel *addressLabel;
    BarImagesView *imagesView;
    
    UIView *votesView;
    UILabel *overallVotesView;
    UILabel *percentageLabel;
    UILabel *likeItLabel;
    
    UIButton*likeButton;
    UIButton *dislikeButton;
    UIButton *undoButton;
    
    UIView *reviewsView;
    UIScrollView * reviewsScrollView;
    
    UIButton *addReviewButton;
    
    HandleProcess *handleProcess;

    NSArray *imagesIdArray;
    
    int posY;
    
}
@property(nonatomic,retain) StreamEntity *entity;
@property(nonatomic,retain) NSString *barCity;
- (id)initWithEntity:(StreamEntity *)entity;


@end
