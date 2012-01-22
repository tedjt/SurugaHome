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
@property (nonatomic, retain) NSNumber * runningCost;
@property (nonatomic, retain) NSNumber * initialCost;
@property (nonatomic, retain) NSNumber * fees;
@property (nonatomic, retain) Home *home;

- (double) getSum;
- (double) getInitialSum;
- (int) getRunningSum;

@end
