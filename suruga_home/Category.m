//
//  Category.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Category.h"
#import "Task.h"


@implementation Category
@dynamic order;
@dynamic name;
@dynamic tasks;

+ (NSArray *)fetchCategoriesWithContext: (NSManagedObjectContext *) context {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    // Fetch Tasks Item
    return [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
//    if (a.count > 0) {
//        NSMutableSet *set = [[[NSMutableSet alloc] init] autorelease];
//        for (Task *t in a) {
//            [set addObject:t.category];
//        }
//        return [set allObjects];
//    }
//    return nil;
}

@end
