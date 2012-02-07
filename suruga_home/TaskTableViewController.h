//
//  TaskTableViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditTaskItemViewController.h"
#import "TaskListTableViewCell.h"

@interface TaskTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, EditTaskItemViewControllerDelegate, TaskListTableViewCellDelegate> {
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;	 
    NSString *categoryName;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSString *categoryName;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)addTask;
@end
