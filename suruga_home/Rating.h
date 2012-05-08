//
//  Rating.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Home;

@interface Rating : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * overall;
@property (nonatomic, retain) NSNumber * first;
@property (nonatomic, retain) NSNumber * second;
@property (nonatomic, retain) NSNumber * third;
@property (nonatomic, retain) NSNumber * fourth;
@property (nonatomic, retain) NSNumber * fifth;
@property (nonatomic, retain) NSNumber * sixth;
@property (nonatomic, retain) Home *home;
/*
 1. Size/Arrangement of room
 2. Price
 3. Surrounding environment
 4. Access
 5. Convenience
 6. Facilities/neat
 */

@end
