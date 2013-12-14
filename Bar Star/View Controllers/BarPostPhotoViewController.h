//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "ASIFormDataRequest.h"
#import "BarServerAPI.h"
#import "HandleProcess.h"

@interface BarPostPhotoViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate,ASIHTTPRequestDelegate,ServerAPIViewDelegate>

{
    UIImageView *mainView;
    
    HandleProcess *handleProcess;

    UIView *titleView;
    UILabel *titleLabel;
    UILabel *addressLabel;
    UIImageView *mainImageView;
    UIButton *postPhotoButton;
    MKMapItem *currentMapItem;
  
    
}
@property(nonatomic,retain)  NSString *percentage;
@property (strong, nonatomic)  UILabel *barNameLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic) UIImage *imageRot;
@property(strong, nonatomic) CLLocationManager *locationManager;

- (id)initWithMapItem:(MKMapItem *)mapItem;
@end
