//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "Annotation.h"

@implementation Annotation

// here we are synthesizing our properties for our Annotation class so that the compiler can make our accessor methods
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize tag;

-init

{
    return self;
    
}


// this is where we implement our initWithCoordinate method
-initWithCoordinate:(CLLocationCoordinate2D)inCoord
{
    coordinate = inCoord;
    return self;
}



- (void)mapView:(MKMapView *)mapView

didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
        
         }
}



@end
