//
//  Price.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Price.h"

@implementation Price
@dynamic deposit;
@dynamic fees;
@dynamic insurance;
@dynamic rentMortgage;
@dynamic taxes;
@dynamic upfrontRent;
@dynamic home;

- (int) getSum {
    return [self.deposit intValue] + [self.fees intValue] + [self.upfrontRent intValue] + [self.rentMortgage intValue] + [self.insurance intValue] + [self.taxes intValue];
}
- (int) getInitialSum {
    return [self.deposit intValue] + [self.fees intValue] + [self.upfrontRent intValue];
    
}
- (int) getRunningSum {
    return  [self.rentMortgage intValue] + [self.insurance intValue] + [self.taxes intValue];
}

@end
