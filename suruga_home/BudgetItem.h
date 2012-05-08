//
//  BudgetItem.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseBudgetItem.h"

@interface BudgetItem : BaseBudgetItem {
@private
}

@property (nonatomic, retain) NSNumber * isExpense;

+ (NSArray *)fetchBudgetItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense;

+ (int) sumItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense;

@end
