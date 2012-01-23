//
//  BoxXRayTableViewController.m
//  DubbleWrap
//
//  Created by Glen Urban on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RoomsTableViewController.h"
#import "suruga_homeAppDelegate.h"
#import "Room.h"
#import "OneRoomTableViewController.h"

@implementation RoomsTableViewController

@synthesize managedObjectContext, fetchedResultsController;



- (void) reload {
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.tableView.editing = NO;
	self.tableView.allowsSelection = YES;
	self.tableView.allowsSelectionDuringEditing = YES;

	
	self.title=NSLocalizedString(@"Rooms ",@"Rooms Table view title");
	
	//add a button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newRoom:)] autorelease];
	
	// Set the table view's row height
    self.tableView.rowHeight = 88.0;
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}


#pragma mark Table view methods

- (void)showRoom:(Room*) room editMode: (BOOL) editMode animated:(BOOL)animated{
	
	OneRoomTableViewController * oneRoomTableViewController = [[OneRoomTableViewController alloc] initWithNibName:@"OneRoomTableViewController" bundle:nil];
    
	oneRoomTableViewController.room = room;
	oneRoomTableViewController.editing = editMode;
	
	[self.navigationController pushViewController:oneRoomTableViewController animated:YES];
	
	[oneRoomTableViewController release];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Room *room = (Room *)[fetchedResultsController objectAtIndexPath:indexPath];
    
    [self showRoom:room editMode: self.editing animated:YES];
}


- (IBAction) newRoom : (id)sender{
	
	// CREATE AND ADD TO DATABASE
	Room *room = (Room*) [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:managedObjectContext];
	
	//NSError * error;
//	if(![managedObjectContext save:&error]){
//		//handle the error
//	}
	
	[self showRoom:room editMode:YES animated:NO];
}


#pragma mark Table view methods

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RoomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[self configureCell:cell atIndexPath:indexPath];	
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	Room *room = (Room *)[fetchedResultsController objectAtIndexPath:indexPath];    
    // Configure the cell to show the Room's details
	cell.textLabel.text = room.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //TODO - make this the total cost of furniture items.
    cell.detailTextLabel.text = [room sumPrices];
    
    if ([room.type isEqualToString:NSLocalizedString(@"Kitchen", @"Kitchen Category")]) {
        cell.imageView.image = [UIImage imageNamed:@"kitchen_icon.jpg"];
    } else if ([room.type isEqualToString:NSLocalizedString(@"Bedroom", @"BedRoom category")]) {
        cell.imageView.image = [UIImage imageNamed:@"bedroom-icon.png"];
    } else if ([room.type isEqualToString:NSLocalizedString(@"Living Room", @"Living Room category")]) {
        cell.imageView.image = [UIImage imageNamed:@"living-room-icon.jpg"];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[fetchedResultsController sections] count];
	
	if (count == 0) {
		count = 1;
	}
	
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		[tableView reloadData];
    }   
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleDelete;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
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
			[self configureCell:(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

