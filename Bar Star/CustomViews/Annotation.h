//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// our new Annotation class is a subclass of NSObject and ALSO conforms to the MKAnnotation protocol
@interface Annotation : NSObject <MKAnnotation>

// this is where we declare the properties of our Annotation class
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) int tag;
-initWithCoordinate:(CLLocationCoordinate2D)inCoord;

@end

