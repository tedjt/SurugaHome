//
//  Room.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Room.h"
#import "Furniture.h"


@implementation Room
@dynamic name;
@dynamic furniture;
@dynamic type;

- (NSString *) sumPrices {
    double total_cost = 0.0;
    NSArray *furnitureSet = [self.furniture allObjects];
    for (Furniture *f in furnitureSet) {
        total_cost = total_cost + [f.price doubleValue];
    }
    return [NSString stringWithFormat:@"$%.2lf",total_cost];
}

@end
