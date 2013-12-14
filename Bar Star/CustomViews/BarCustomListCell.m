//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarCustomListCell.h"
#import "BarUtility.h"
#import "AFImageRequestOperation.h"

@implementation BarCustomListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initControls];
    }
    return self;
}

-(void)dealloc
{
    [barImage release];
    [dateLabel release];
   [titleLabel release];
    [addressLabel release];
   [distanceLabel release];
   [percentageLabel release];
    [super dealloc];
    
}
-(void) initControls
{
      self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[BarUtility LIST_CELL_BG_IMAGE]]];
    
    int posX = 10;
    int posY = 5;
    barImage = [[UIImageView alloc]initWithFrame:CGRectMake(posX, posY,100,100)];
   
    [barImage setImage:[UIImage imageNamed:[BarUtility LIST_CELL_BAR_IMAGE]]];
     [self addSubview:barImage];
    
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, barImage.frame.size.height - 32, barImage.frame.size.width - 15, 30)];
    [self addSubview:dateLabel];
    
    posX = posX + barImage.frame.size.width + 10;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, self.frame.size.width - posX, 27)];
    [self addSubview:titleLabel];
    
    posY = posY + titleLabel.frame.size.height ;
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, self.frame.size.width - posX, 25)];
    [self addSubview:addressLabel];
    
    posY = posY + addressLabel.frame.size.height ;
    
    distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(posX, posY, self.frame.size.width - posX, 30)];
    [self addSubview:distanceLabel];
   
    
    posY = posY + distanceLabel.frame.size.height - 20;
    
    percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, posY, 50, 30)];
    [self addSubview:percentageLabel];
    titleLabel.text = @"title ";
    addressLabel.text =@"address";
    dateLabel.text = @"date ";
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    dateLabel.backgroundColor = [UIColor blackColor];
    dateLabel.alpha = 0.7;
    distanceLabel.backgroundColor = [UIColor clearColor];
    percentageLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.textColor = UIColorFromRGB(0xE8B619);
    addressLabel.textColor = UIColorFromRGB(0x919395);
    distanceLabel.textColor = [UIColor whiteColor];
    percentageLabel.textColor = [UIColor whiteColor];
    
    dateLabel.textColor = [UIColor whiteColor];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    addressLabel.font = [UIFont boldSystemFontOfSize:15];
    percentageLabel.font = [UIFont boldSystemFontOfSize:18];
    distanceLabel.font = [UIFont boldSystemFontOfSize:13];

    
    
}

-(void) calculateDistance:(NSString *)lat withLong:(NSString *)longi
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    float lat2 = [lat floatValue];
    float lon2 = [longi floatValue];
   
    float currentLat =    [prefs floatForKey:@"latitude"];
    float currentLong = [prefs floatForKey:@"longitude"];

   
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:currentLat longitude:currentLong];
    

     
    double distanceCalc = [location1 distanceFromLocation:location2] / 1000;
    
  
    
    NSString* myNewString = [NSString stringWithFormat:@"%0.3f km", distanceCalc];
    distanceLabel.text = myNewString;
    
    

}
#define kThumbSide 110
#define kPadding 10

-(void) setValuesForCell:(StreamEntity *)entity
{
    
    titleLabel.text = entity.barTitle;
    addressLabel.text = entity.address;
    dateLabel.text = entity.datetime;
    percentageLabel.text =[NSString stringWithFormat:@"%@%%", entity.percentage];
    
    [self calculateDistance:entity.latitude withLong:entity.longitude];
    
    //initialize
    self.tag = [entity.photoId intValue];
    // self.tag = [[data objectForKey:@"dataLabel"] intValue];
    
    
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.numberOfLines =  0;
    dateLabel.font = [UIFont boldSystemFontOfSize:10];
//    dateLabel.text = [NSString stringWithFormat:@"%@",entity.datetime];
//    [self addSubview: dateLabel];
    
    
    
    //step 2
    //add touch event
    
    //load the image
    int IdPhoto = [entity.photoId intValue];
    NSURL* imageURL = [BarServerAPI urlForImageWithId:[NSNumber numberWithInt: IdPhoto] isThumb:YES];
    
    AFImageRequestOperation* imageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL]
                                                      success:^(UIImage *image) {
                                                          //create an image view, add it to the view
                                                         
                                                          [barImage setImage:image];
                                                          
                                                          barImage.contentMode = UIViewContentModeCenter;
                                                                                                            barImage.layer.cornerRadius = 23;//23
                                                          
                                                          
                                                          barImage.layer.borderColor = [UIColor clearColor].CGColor;

                                                          barImage.layer.borderWidth = 1;
                                                          
                                                          dateLabel.layer.cornerRadius = 8;
                                                          
                                                          
                                                          dateLabel.layer.borderColor = [UIColor clearColor].CGColor;
                                                          
                                                          dateLabel.layer.borderWidth = 1;
                                                          

                                                          
                                                          barImage.clipsToBounds = YES;
                                                          
                                                
                                                      }];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:imageOperation];

    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
