//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BarServerAPI.h"
#import "AFImageRequestOperation.h"

#import "HandleProcess.h"
@interface BarViewPhotoViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    
    UIScrollView *imagesScroll;
    UIImageView *mainView;
    
    HandleProcess *handleProcess;
    StreamEntity *streamEntity;
    
}
-(void) setImagesForScrollView:(NSArray *)iamgesidArray;
- (id)initWithEntity:(StreamEntity *)entity;

@end
