//
//  TaskListTableViewCell.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskListTableViewCell;

@protocol TaskListTableViewCellDelegate<NSObject>

@required
- (void)tableViewCellIconTouched:(TaskListTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end

@interface TaskListTableViewCell : UITableViewCell {
    id<TaskListTableViewCellDelegate> touchIconDelegate;       // note: not retained
    NSIndexPath *touchIconIndexPath;
}

@property (nonatomic, assign) id<TaskListTableViewCellDelegate> touchIconDelegate;
@property (nonatomic, retain) NSIndexPath *touchIconIndexPath;

@end
