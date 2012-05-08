//
//  Home.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "HomeBudgetItem.h"
#import "BudgetItem.h"
#import "ManagedObjectCloner.h"


@implementation Home
@dynamic name;
@dynamic phone;
@dynamic notes;
@dynamic layout;
@dynamic stationDistance;
@dynamic size;
@dynamic isRent;
@dynamic rating;
@dynamic images;
@dynamic budgetItems;
@dynamic address;
@dynamic latitude;
@dynamic longitude;

+ (NSArray *)fetchAllHomesWithContext: (NSManagedObjectContext *) context {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Home" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    // Fetch UserData Item
    NSArray *a = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    return a;
}

- (int) getTotalCost {
    int totalCost = 0;
    for (HomeBudgetItem *b in self.budgetItems) {
        totalCost = totalCost + [b.amount intValue];     
    }
    return totalCost;
    //return [NSString stringWithFormat:@"$%d",(int)total_cost];
}

- (int) getInitialCost {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inInitialBudget == %@ AND (isRenting == %@ OR isRenting == %@)", [NSNumber numberWithBool:YES], self.isRent, [NSNumber numberWithInt:3]];
    NSSet *results = [self.budgetItems filteredSetUsingPredicate: predicate];
    int totalCost = 0;
    for (HomeBudgetItem *b in results) {
        totalCost = totalCost + [b.amount intValue];     
    }
    return totalCost;
    //return [NSString stringWithFormat:@"$%d",(int)total_cost];
}

- (int) getRunningCost {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inInitialBudget == %@ AND (isRenting == %@ OR isRenting == %@)", [NSNumber numberWithBool:NO], self.isRent, [NSNumber numberWithInt:3]];
    NSSet *results = [self.budgetItems filteredSetUsingPredicate: predicate];
    int totalCost = 0;
    for (HomeBudgetItem *b in results) {
        totalCost = totalCost + [b.amount intValue];     
    }
    return totalCost;
    //return [NSString stringWithFormat:@"$%d",(int)total_cost];
}

- (void) populateDefaultBudgetItems {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomeBudgetItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //Set up predicates to use all HomeBudgetItems with no home attribute set.
    NSPredicate *testForNilHome =
    [NSPredicate predicateWithFormat:@"home == %@", nil];
    [fetchRequest setPredicate:testForNilHome];
    NSError *error;
    // Fetch Cost Items
    NSArray *defaultBudgetItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (HomeBudgetItem *b in defaultBudgetItems) {
        // Deep clone object
        HomeBudgetItem *c = (HomeBudgetItem *)[ManagedObjectCloner clone:b inContext:self.managedObjectContext];
        c.home = self;
        [self addBudgetItemsObject:c];
    }
    // save home with all the new default budgetItems
    if (![self.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

}

- (NSMutableArray *)fetchBudgetItemsInInitial: (BOOL) inInitial {
    //Figure out if user is renting our not
    bool isRenting = [self.isRent boolValue];
    //Set up predicates
    NSPredicate *testForInitialAndRent =
    [NSPredicate predicateWithFormat:@"inInitialBudget == %@ AND (isRenting == %@ OR isRenting == %@)", [NSNumber numberWithBool:inInitial], [NSNumber numberWithBool:isRenting], [NSNumber numberWithInt:3]];
    
    // get relevant results in a new set
    NSSet *filteredHomes = [self.budgetItems filteredSetUsingPredicate: testForInitialAndRent];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
    
    //Return mutable array
    return [NSMutableArray arrayWithArray: [filteredHomes sortedArrayUsingDescriptors:sortDescriptors]]; 
}

- (int) getInitialCapacity {
    int initialCost = [self getInitialCost];
    int surplusIncome = [BudgetItem sumItemsWithContext:self.managedObjectContext inInitial:YES isExpense:NO] - [BudgetItem sumItemsWithContext:self.managedObjectContext inInitial:YES isExpense:YES];
    return surplusIncome - initialCost;    
}

- (int) getRunningCapacity {
    int runningCost = [self getRunningCost];
    int surplusIncome = [BudgetItem sumItemsWithContext:self.managedObjectContext inInitial:NO isExpense:NO] - [BudgetItem sumItemsWithContext:self.managedObjectContext inInitial:NO isExpense:YES];
    return surplusIncome - runningCost;    
}

- (CLLocationCoordinate2D) getCoordinate {
    if (self.latitude != nil) {
        return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    }
    return CLLocationCoordinate2DMake(0.0, 0.0);
};

@end
