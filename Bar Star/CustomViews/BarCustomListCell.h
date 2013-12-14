//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

#import <QuartzCore/QuartzCore.h>
#import "BarServerAPI.h"

@interface BarCustomListCell : UITableViewCell
{
    UIImageView *barImage;
    UILabel *dateLabel;
    UILabel *titleLabel;
    UILabel *addressLabel;
    UILabel *distanceLabel;
    UILabel *percentageLabel;
    
}
-(void) setValuesForCell:(StreamEntity *)entity;

@end
