//
//  TaskTableViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeTableViewController.h"
#import "suruga_homeAppDelegate.h"
#import "Home.h"
#import "Address.h"
#import "Image.h"
#import "HomeMapAnnotation.h"

//#import "TaskTableViewCell.h"

@implementation HomeTableViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize mTableView;
@synthesize mapView;

@synthesize managedObjectContext, fetchedResultsController;

#pragma mark - Private Functions

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewController" owner:self options:nil];
    
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.mTableView.editing = NO;
	self.mTableView.allowsSelection = YES;
	self.mTableView.allowsSelectionDuringEditing = YES;
    // Set the table view's row height
    self.mTableView.rowHeight = 44.0;
	
	self.title=NSLocalizedString(@"Home List",@"Home List Title");
    
    // Configure the add button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHome)] autorelease];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    //Configure MapView
    self.mapView = [[MKMapView alloc] initWithFrame: CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
    self.mapView.delegate = self;
    [self.scrollView addSubview:self.mapView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    
    // Add Annotations
    [self loadMapViewAnnotations];
    //TODO Make the mapview have the right zoom for the annotations.

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setMTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mTableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Should be only 1 section for Homes
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the tasks's name
	Home  *home = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = home.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Image *imageObject = [home.images anyObject];
    if (imageObject != nil) {
        cell.imageView.image = [UIImage imageWithData:imageObject.thumb];
    }
    cell.detailTextLabel.text = home.address.street;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        //Delete all the images in the filesystem
        Home *homeObject = [fetchedResultsController objectAtIndexPath:indexPath];
        NSArray *imagesArrary = [homeObject.images allObjects];
        for (Image *image in imagesArrary) {
            [[NSFileManager defaultManager] removeItemAtPath:image.pathToFull error:nil];
        }
        // delete the object
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
        [self loadMapViewAnnotations];
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
	HomeDetailViewController *homeDetailViewController = [[HomeDetailViewController alloc] initWithNibName:@"HomeDetailViewController 2" bundle:nil];
    // Find selected task
    Home *selectedHome = (Home *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected task to the new view controller.
    homeDetailViewController.home = selectedHome;
    homeDetailViewController.parentController = self;
    
    // Push the task view to the navigation controller.
    [self.navigationController pushViewController:homeDetailViewController animated:YES];
    [homeDetailViewController release];
}

- (IBAction)addHome {
	
    HomeDetailViewController *detailViewController = [[HomeDetailViewController alloc] initWithNibName:@"HomeDetailViewController 2" bundle:nil];
    
	detailViewController.home = (Home *)[NSEntityDescription insertNewObjectForEntityForName:@"Home" inManagedObjectContext:managedObjectContext];
    detailViewController.parentController = self;
	
    // Push the task view to the navigation controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark -

/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)homeDetailViewController:(HomeDetailViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		/*
		 The new task is associated with the task controller's managed object context.
		 This is good because it means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad -- but it does make it more difficult to get the new book registered with the fetched results controller.
		 First, you have to save the new book.  This means it will be added to the persistent store.  Then you can retrieve a corresponding managed object into the application delegate's context.  Normally you might do this using a fetch or using objectWithID: -- for example
		 
		 NSManagedObjectID *newBookID = [controller.book objectID];
		 NSManagedObject *newBook = [applicationContext objectWithID:newBookID];
		 
		 These techniques, though, won't update the fetch results controller, which only observes change notifications in its context.
		 You don't want to tell the fetch result controller to perform its fetch again because this is an expensive operation.
		 You can, though, update the main context using mergeChangesFromContextDidSaveNotification: which will emit change notifications that the fetch results controller will observe.
		 To do this:
		 1	Register as an observer of the task controller's change notifications
		 2	Perform the save
		 3	In the notification method (addControllerContextDidSave:), merge the changes
		 4	Unregister as an observer
		 */
        // Save the changes.
		NSError *error;
		if (![self.fetchedResultsController.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
    
	// Dismiss the modal view to return to the main list
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadMapViewAnnotations {
    //Remove all annotations
    for (id annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]){
            [self.mapView removeAnnotation:annotation];
        }
    }
    // add annotations.
    for (Home *home in [self.fetchedResultsController fetchedObjects])
    {
        if (home.address != nil && home.address.latitude != nil && fabs([home.address.latitude doubleValue]) > 0.001) {
            HomeMapAnnotation *annotation = [[[HomeMapAnnotation alloc] init] autorelease];
            annotation.title = home.name;
            annotation.subtitle = [home.address getFormattedAddress];
            annotation.coordinate = [home.address getCoordinate];
            Image *imageObject = [home.images anyObject];
            if (imageObject != nil) {
                annotation.image = [UIImage imageWithData:imageObject.thumb];
            }
            annotation.home = home;
            [self.mapView addAnnotation:annotation];
        }
    }
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Home" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
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

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle custom annotations for each home.

    // try to dequeue an existing pin view first
    static NSString* HomeAnnotationIdentifier = @"homeAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:HomeAnnotationIdentifier];
    if (!pinView)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc] 
            initWithAnnotation:annotation reuseIdentifier:HomeAnnotationIdentifier] autorelease];
        customPinView.pinColor = MKPinAnnotationColorRed;
        //customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //TODO
        customPinView.leftCalloutAccessoryView = [[[UIImageView alloc] initWithImage:[(HomeMapAnnotation *) annotation image]] autorelease];
        
        return customPinView;
        } else {
            pinView.annotation = annotation;
            pinView.leftCalloutAccessoryView =[[[UIImageView alloc] initWithImage:[(HomeMapAnnotation *) annotation image]] autorelease];
        }
        return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Load Detail view controller
    
    // Create and push a detail view controller.
	HomeDetailViewController *homeDetailViewController = [[HomeDetailViewController alloc] initWithNibName:@"HomeDetailViewController 2" bundle:nil];
    
    // Pass the selected Home to the new view controller.
    homeDetailViewController.home = [(HomeMapAnnotation *) view.annotation home];
    homeDetailViewController.parentController = self;
    
    // Push the task view to the navigation controller.
    [self.navigationController pushViewController:homeDetailViewController animated:YES];
    [homeDetailViewController release];
    //TODO
}

#pragma mark memory maanagement

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [scrollView release];
    [pageControl release];
    [mTableView release];
    [mapView release];
    [super dealloc];
}

@end
