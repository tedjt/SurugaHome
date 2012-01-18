//
//  Task.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;
@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) Category * category;
@property (nonatomic, retain) NSNumber * order;

@end
