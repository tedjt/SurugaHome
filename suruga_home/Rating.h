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
@property (nonatomic, retain) NSNumber * location;
@property (nonatomic, retain) NSNumber * transportation;
@property (nonatomic, retain) NSNumber * parks;
@property (nonatomic, retain) NSNumber * food;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * kitchen;
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
