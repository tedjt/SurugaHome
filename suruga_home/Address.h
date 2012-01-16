//
//  Address.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class Home;

@interface Address : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@property (nonatomic, retain) Home *home;

- (NSString *) getFormattedAddress;
- (CLLocationCoordinate2D) getCoordinate;


@end
