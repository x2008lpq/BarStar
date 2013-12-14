//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol DetailImageViewDelegate <NSObject>

-(void) didImageTapped:(id)sender;

@end
@interface BarImagesView : UIView
{

    UIImageView *mainView;
    UIButton *leftArrow;
    UIButton *rightArrow;
    UILabel *titleLabel;
    UIScrollView *imagesScroll;
    
}
@property(nonatomic,assign) id<DetailImageViewDelegate> delegate;

-(void) setImagesForScrollView:(NSArray *)iamgesidArray;

@end
