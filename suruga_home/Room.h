//
//  Room.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Furniture;

@interface Room : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * width;
@property (nonatomic, retain) NSString * length;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *furniture;

- (NSString *) sumPrices;
+ (NSString *) allRoomsTotalWithContext:(NSManagedObjectContext *) context;

@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addFurnitureObject:(Furniture *)value;
- (void)removeFurnitureObject:(Furniture *)value;
- (void)addFurniture:(NSSet *)values;
- (void)removeFurniture:(NSSet *)values;
@end
