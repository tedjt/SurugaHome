//
//  BudgetItem.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetItem.h"


@implementation BudgetItem
@dynamic amount;
@dynamic isExpense;
@dynamic name;
@dynamic notes;
@dynamic inInitialBudget;

+ (NSArray *)fetchBudgetItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense {
    //Initialize Data Arrays
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BudgetItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //Set up predicates
    NSPredicate *testForInitialAndExpense =
    [NSPredicate predicateWithFormat:@"inInitialBudget == %@ AND isExpense == %@", [NSNumber numberWithBool:inInitial], [NSNumber numberWithBool:expense]];
    [fetchRequest setPredicate:testForInitialAndExpense];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    // Fetch Cost Items
    return [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
}

@end
