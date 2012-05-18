//
//  BudgetItem.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BudgetItem : NSManagedObject {
@private
}

@property (nonatomic, retain) NSNumber * isExpense;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * isRenting;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * advisorUrl;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * inInitialBudget;

+ (NSArray *)fetchBudgetItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense;

+ (int) sumItemsWithContext: (NSManagedObjectContext *) context inInitial: (BOOL) inInitial isExpense: (BOOL) expense;

@end
