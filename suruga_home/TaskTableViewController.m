//
//  TaskTableViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskTableViewController.h"
#import "suruga_homeAppDelegate.h"
#import "Task.h"
#import "Category.h"

//#import "TaskTableViewCell.h"

@implementation TaskTableViewController

@synthesize managedObjectContext, fetchedResultsController;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.tableView.editing = NO;
	self.tableView.allowsSelection = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
    // Set the table view's row height
    self.tableView.rowHeight = 44.0;
	
	self.title=NSLocalizedString(@"Task List",@"Task List Title");
    
    // Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TaskListTableViewCell *cell = (TaskListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TaskListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease]; 
        cell.touchIconDelegate = self; 
    }
    
    // Configure the cell...
    cell.touchIconIndexPath = indexPath;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the tasks's name
	Task  *task = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = task.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"%@circle-check-logo.png", [task.completed boolValue] ? @"":@"unchecked_" ]];
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:task.dueDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]; 
}

- (void)tableViewCellIconTouched:(TaskListTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    //Checkbox has been clicked.
    Task  *task = [fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([task.completed boolValue]) {
        cell.imageView.image = [UIImage imageNamed:@"unchecked_circle-check-logo.png"];
        task.completed = [NSNumber numberWithBool:NO];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"circle-check-logo.png"];
        task.completed = [NSNumber numberWithBool:YES];
    }
    //Commit the change
    NSError *error;
    if (![task.managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the category Names as section headings.
    NSIndexPath *p = [NSIndexPath indexPathForRow:0 inSection:section];
    Task *t = [fetchedResultsController objectAtIndexPath:p];
    return t.category.name;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create and push a detail view controller.
	EditTaskItemViewController *taskViewController = [[EditTaskItemViewController alloc] initWithNibName:@"EditTaskItemViewController" bundle:nil];
    taskViewController.parentController = self;
    // Find selected task
    Task *selectedTask = (Task *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected task to the new view controller.
    taskViewController.task = selectedTask;
    
    // Create a modal view controller to handle the task view.
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:taskViewController];
	[self.navigationController presentModalViewController:navController animated:YES];
    
    // Clean up
	[taskViewController release];
    [navController release];
}

- (IBAction)addTask {
	
    EditTaskItemViewController *taskViewController = [[EditTaskItemViewController alloc] initWithNibName:@"EditTaskItemViewController" bundle:nil];
    taskViewController.parentController = self;
    
	taskViewController.task = (Task *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:taskViewController];
	
    [self.navigationController presentModalViewController:navController animated:YES];
	
	[taskViewController release];
	[navController release];
}

/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)taskViewController:(EditTaskItemViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}
    
	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *categoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category.order" ascending:YES];
    //NSSortDescriptor *completedDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completed" ascending:YES];
    NSSortDescriptor *dueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSSortDescriptor *orderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: categoryDescriptor, orderDescriptor, dueDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"category.order" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[dueDescriptor release];
	[categoryDescriptor release];
    //[completedDescriptor release];
    [orderDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}


#pragma mark -
#pragma mark memory maanagement

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

@end
