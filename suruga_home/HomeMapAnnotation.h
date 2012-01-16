//
//  HomeMapAnnotation.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Home.h"

@interface HomeMapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    UIImage *image;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) Home *home;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@end


