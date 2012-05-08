//
//  BaseBudgetItem.h
//  suruga_home
//
//  Created by Ted Tomlinson on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseBudgetItem : NSManagedObject{
@private
}

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isRenting;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * advisorUrl;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * inInitialBudget;

@end
