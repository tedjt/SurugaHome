//
//  BudgetItem.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetItem.h"
#import "UserData.h"


@implementation BudgetItem
@dynamic isExpense;
@dynamic amount;
@dynamic order;
@dynamic isRenting;
@dynamic name;
@dynamic notes;
@dynamic inInitialBudget;
@dynamic advisorUrl;

+ (NSArray *)fetchBudgetItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense {
    //Figure out if user is renting our not
    bool isRenting = [UserData isUserRentingWithContext:context];
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //Set up predicates
    NSPredicate *testForInitialAndExpense =
    [NSPredicate predicateWithFormat:@"inInitialBudget == %@ AND isExpense == %@ AND (isRenting == %@ OR isRenting == %@)", [NSNumber numberWithBool:inInitial], [NSNumber numberWithBool:expense], [NSNumber numberWithBool:isRenting], [NSNumber numberWithInt:3]];
    [fetchRequest setPredicate:testForInitialAndExpense];
    // Edit the sort key as appropriate.
    NSSortDescriptor *orderDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES] autorelease];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:orderDescriptor, sortDescriptor, nil] autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    // Fetch Cost Items
    return [context executeFetchRequest:fetchRequest error:&error];
    
}

+ (int) sumItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense {
    int cost = 0;
    for (BudgetItem *b in [BudgetItem fetchBudgetItemsWithContext:context inInitial:inInitial isExpense:expense]) {
        cost = cost + [b.amount intValue];
    }
    return cost;
}

@end
