//
//  HomeLaunchViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditTaskItemViewController.h"
#import "TaskListTableViewCell.h"

@class Category;
@interface HomeLaunchViewController : UIViewController <NSFetchedResultsControllerDelegate, EditTaskItemViewControllerDelegate, TaskListTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSFetchedResultsController *fetchedResultsController;
    UITableView *mTableView;
    UIButton *imageButton;
    UIButton *textButton;
    UILabel *checklistLabel;
    NSManagedObjectContext *managedObjectContext;
    
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIButton *imageButton;
@property (nonatomic, retain) IBOutlet UIButton *textButton;
@property (nonatomic, retain) IBOutlet UILabel *checklistLabel;

//Configuration properties
@property (nonatomic, retain) NSString *pageTitle;
@property (nonatomic, retain) UIViewController *nextVC;
@property (nonatomic, retain) NSPredicate *fetchPredicate;
@property (nonatomic, retain) Category *category;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)addTask;
- (IBAction)homesButtonClicked:(id)sender;
@end