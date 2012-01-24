//
//  Category.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;

+ (NSArray *)fetchCategoriesWithContext: (NSManagedObjectContext *) context;
+ (Category *)fetchCategoryWithName: (NSString *) name context: (NSManagedObjectContext *) context;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;
@end
