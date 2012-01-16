//
//  Address.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Address.h"
#import "Home.h"


@implementation Address
@dynamic street;
@dynamic city;
@dynamic state;
@dynamic zip;
@dynamic latitude;
@dynamic longitude;
@dynamic home;

- (NSString *) getFormattedAddress {
    return [self.zip intValue] == 0 ? [NSString stringWithFormat:@"%@, %@ %@", self.street, self.city, self.state] :
    [NSString stringWithFormat:@"%@, %@ %@ %d", self.street, self.city, self.state, [self.zip intValue]];
}
- (CLLocationCoordinate2D) getCoordinate {
    if (self.latitude != nil) {
        return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
};

@end
