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
@dynamic width;
@dynamic length;
@dynamic furniture;
@dynamic type;

+ (NSString *) allRoomsTotalWithContext: (NSManagedObjectContext *) context {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    // Fetch Room Items
    NSArray *rooms =  [context executeFetchRequest:fetchRequest error:&error];
    int total_cost = 0;
    for (Room *r in rooms) {
        NSArray *furnitureSet = [r.furniture allObjects];
        for (Furniture *f in furnitureSet) {
            total_cost = total_cost + [f.price intValue];
        }
    }
    return [NSString stringWithFormat:@"$%d",(int)total_cost];
}

- (NSString *) sumPrices {
    int total_cost = 0;
    NSArray *furnitureSet = [self.furniture allObjects];
    for (Furniture *f in furnitureSet) {
        total_cost = total_cost + [f.price intValue];
    }
    return [NSString stringWithFormat:@"$%d",(int)total_cost];
}

@end
