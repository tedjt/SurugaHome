//
//  HomeLaunchViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeLaunchViewController.h"
#import "suruga_homeAppDelegate.h"
#import "HomeTableViewController.h"
#import "Task.h"
#import "Category.h"

@implementation HomeLaunchViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize mTableView;
@synthesize imageButton;
@synthesize textButton;
@synthesize checklistLabel;

//conifigurable
@synthesize pageTitle;
@synthesize nextVC;
@synthesize fetchPredicate;
@synthesize category;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.mTableView.editing = NO;
	self.mTableView.allowsSelection = YES;
	self.mTableView.allowsSelectionDuringEditing = YES;
    // Set the table view's row height
    self.mTableView.rowHeight = 44.0;
	
	self.title=self.pageTitle;
    
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
    [self setImageButton:nil];
    [self setTextButton:nil];
    [self setChecklistLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setMTableView:nil];
    self.fetchedResultsController = nil;
    
    //configurable options
    self.pageTitle = nil;
    self.nextVC = nil;
    self.fetchPredicate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.mTableView reloadData];
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
    
    [self.mTableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the category Names as section headings, but not for the default category
    if (section == 0) {
        return nil;
    }
    else {
        NSIndexPath *p = [NSIndexPath indexPathForRow:0 inSection:section];
        Task *t = [fetchedResultsController objectAtIndexPath:p];
        return t.category.name;
    }
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

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [self.mTableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create and push a detail view controller.
	EditTaskItemViewController *taskViewController = [[EditTaskItemViewController alloc] initWithNibName:@"EditTaskItemViewController" bundle:nil];
    taskViewController.parentController = self;
    // Find selected task
    Task *selectedTask = (Task *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected task to the new view controller.
    taskViewController.task = selectedTask;
	[self.navigationController pushViewController:taskViewController animated:YES];
    
    // Clean up
	[taskViewController release];
    //[navController release];
}

- (IBAction)addTask {
	
    EditTaskItemViewController *taskViewController = [[EditTaskItemViewController alloc] initWithNibName:@"EditTaskItemViewController" bundle:nil];
    taskViewController.parentController = self;
    
	taskViewController.task = (Task *)[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
    taskViewController.task.category = self.category;
	
	//UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:taskViewController];
    [self.navigationController pushViewController:taskViewController animated:YES];
	
	[taskViewController release];
	//[navController release];
}

- (IBAction)homesButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.nextVC animated:YES];	
    
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
    
	// Dismiss the edit view to return to the main list
    [self.navigationController popViewControllerAnimated:YES];
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
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: categoryDescriptor, dueDescriptor, orderDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    //Set up predicate
    [NSFetchedResultsController deleteCacheWithName:self.pageTitle];
    fetchRequest.predicate = self.fetchPredicate;
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"category.order" cacheName:self.pageTitle];
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
	[self.mTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.mTableView;
    
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
			[self.mTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.mTableView endUpdates];
}


#pragma mark -

- (void)dealloc {
    [mTableView release];
    [fetchedResultsController release];
	[managedObjectContext release];
    //Configurable
    [pageTitle release];
    [nextVC release];
    [fetchPredicate release];
    [imageButton release];
    [textButton release];
    [checklistLabel release];
    [super dealloc];
}
@end
