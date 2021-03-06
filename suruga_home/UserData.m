//
//  UserData.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"


@implementation UserData
@dynamic isRenting;
@dynamic name;
@dynamic reason;
@dynamic when;
@dynamic numBeds;
@dynamic numBaths;
@dynamic numPeople;

+ (UserData *)fetchUserDataWithContext: (NSManagedObjectContext *) context {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    // Fetch UserData Item
    NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    if (a.count > 0) {
        return [a objectAtIndex: 0];
    }
    return nil;
}

+ (void) setUserRentingWithContext: (NSManagedObjectContext *) context val: (BOOL) val {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    // Fetch UserData Item
    NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    if (a.count > 0) {
        UserData *u = [a objectAtIndex: 0];
        u.isRenting = [NSNumber numberWithBool:val];
        NSError *error;
        if (![u.managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
    }
    
}

+ (bool) isUserRentingWithContext: (NSManagedObjectContext *) context {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    // Fetch UserData Item
    NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    if (a.count > 0) {
        UserData *u = [a objectAtIndex: 0];
        return [u.isRenting boolValue];
    }
    return NO;
    
}

@end
