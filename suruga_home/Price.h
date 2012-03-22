//
//  Price.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Home;

@interface Price : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * deposit;
@property (nonatomic, retain) NSNumber * fees;
@property (nonatomic, retain) NSNumber * insurance;
@property (nonatomic, retain) NSNumber * rentMortgage;
@property (nonatomic, retain) NSNumber * taxes;
@property (nonatomic, retain) NSNumber * upfrontRent;
@property (nonatomic, retain) Home *home;

- (int) getSum;
- (int) getInitialSum;
- (int) getRunningSum;

@end
