//
//  Price.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Price.h"

@implementation Price
@dynamic runningCost;
@dynamic initialCost;
@dynamic fees;
@dynamic home;

- (double) getSum {
    return [self.runningCost doubleValue] + [self.initialCost doubleValue] + [self.fees doubleValue];
}
- (double) getInitialSum {
        return [self.initialCost doubleValue] + [self.fees doubleValue];
    
}
- (int) getRunningSum {
    return [self.runningCost intValue];
}

@end
