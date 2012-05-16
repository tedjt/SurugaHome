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
#import "Image.h"
#import "HomeMapAnnotation.h"
#import "UIButton+setTitleText.h"
#import "BudgetTableViewController.h"
#import "SurplusDetailsViewController.h"
#import "SimpleSurplusViewController.h"

//#import "TaskTableViewCell.h"

@implementation HomeTableViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize mTableView;
@synthesize mTableViewPrice;

@synthesize managedObjectContext, fetchedResultsController;

#pragma mark - Private Functions
enum {
    kTermLabelTag = 1,
    kDetailLabelTag = 2
};

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewController" owner:self options:nil];
    
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // Set up table views
	self.mTableView.editing = NO;
	self.mTableView.allowsSelection = YES;
	self.mTableView.allowsSelectionDuringEditing = YES;
    // Set the table view's row height
    self.mTableView.rowHeight = 117.0;
    
	
	self.title=NSLocalizedString(@"Comparison List",@"Home List Title");
    
    // Configure the add button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHome)] autorelease];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    // configure price comparison table
    self.mTableViewPrice = [[[UITableView alloc] initWithFrame: CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)]autorelease];
    self.mTableViewPrice.delegate = self;
    self.mTableViewPrice.dataSource = self;
    self.mTableViewPrice.editing = NO;
	self.mTableViewPrice.allowsSelection = YES;
	self.mTableViewPrice.allowsSelectionDuringEditing = YES;
    // Set the table view's row height
    self.mTableViewPrice.rowHeight = 117.0;
    
    // Add table view to the second pane.
    [self.scrollView addSubview:self.mTableViewPrice];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    

}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setMTableView:nil];
    [self setMTableViewPrice:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mTableView reloadData];
    [self.mTableViewPrice reloadData];
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
    UITableViewCell *cell;
    // Configure the cell...
    if (tableView == self.mTableView) {
        static NSString *HomeCellId = @"HomeTableViewCellId";
        
        cell = [tableView dequeueReusableCellWithIdentifier:HomeCellId];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        [self configureLocationCell:cell atIndexPath:indexPath];
    }
    else {
        static NSString *HomeCellPriceId = @"HomeTableViewCellPriceId";
        
        cell = [tableView dequeueReusableCellWithIdentifier:HomeCellPriceId];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCellPrice" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }

        [self configurePriceCell:cell atIndexPath: indexPath];
    }
    return cell;
}

- (void)configureLocationCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //Enum to hold the cell element tags
    enum {
        kHomeImageViewTag = 1,
        kNameLabelTag = 2,
        kRatingImageTag = 3,
        kStationLabelTag = 4,
        kSizeLabelTag = 5
    };
	
    // Configure the cell to show the tasks's name
    UIImageView *homeImageView = (UIImageView *)[cell viewWithTag:kHomeImageViewTag];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag: kNameLabelTag];
    UIImageView *ratingImageView = (UIImageView *)[cell viewWithTag:kRatingImageTag];
    UILabel *stationLabel = (UILabel *)[cell viewWithTag: kStationLabelTag];
    UILabel *sizeLabel = (UILabel *)[cell viewWithTag: kSizeLabelTag];

	Home  *home = [fetchedResultsController objectAtIndexPath:indexPath];
	nameLabel.text = home.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Image *imageObject = [home.images anyObject];
    if (imageObject != nil) {
        homeImageView.image = [UIImage imageWithData:imageObject.thumb];
    }
    if (home.rating.overall != nil) {
        ratingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_stars.png", [home.rating.overall intValue]]];                                          
    }
    //TODO internationailize
    stationLabel.text = [NSString stringWithFormat:@"%d minutes", [home.stationDistance intValue]];
    sizeLabel.text = [NSString stringWithFormat:@"%d square meters", [home.size intValue]]; 
}

- (void)configurePriceCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //Enum to hold the cell element tags
    enum {
        kHomeImageViewTag = 1,
        kInitialTag = 2,
        kInitialCapacityTag = 3,
        kRunningTag = 4,
        kRunningCapacityTag = 5
    };
	
    // Configure the cell to show the tasks's name
    UIImageView *homeImageView = (UIImageView *)[cell viewWithTag:kHomeImageViewTag];
    UILabel *initialCost = (UILabel *)[cell viewWithTag: kInitialTag];
    UIButton *initialCapacity = (UIButton *) [cell viewWithTag:kInitialCapacityTag];
    UILabel *runningCost = (UILabel *)[cell viewWithTag: kRunningTag];
    UIButton *runningCapacity = (UIButton *) [cell viewWithTag:kRunningCapacityTag];
    
	Home  *home = [fetchedResultsController objectAtIndexPath:indexPath];
    // Set initial cost labels
    initialCost.text = [NSString stringWithFormat:NSLocalizedString(@"$%d", @"Dollar formated cost"),[home getInitialCost]];
    [initialCapacity setTitleText: [NSString stringWithFormat:NSLocalizedString(@"$%d", @"Dollar formated cost"),[home getInitialCapacity]]];
    [initialCapacity addTarget:self action:@selector(runningBudgetClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    // Set Running cost labels
    runningCost.text = [NSString stringWithFormat:NSLocalizedString(@"$%d", @"Dollar formated cost"),[home getRunningCost]];
    [runningCapacity setTitleText: [NSString stringWithFormat:NSLocalizedString(@"$%d", @"Dollar formated cost"),[home getRunningCapacity]]];
    [runningCapacity addTarget:self action:@selector(runningBudgetClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    // Set home image if available.
    Image *imageObject = [home.images anyObject];
    if (imageObject != nil) {
        homeImageView.image = [UIImage imageWithData:imageObject.thumb];
    }
    // TODO Set capacity buttons to link to appropriate budget. (three20)
    // Set disclosure indictor
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

//Budget Actions
- (IBAction)initialBudgetClicked:(id)sender {
//    BudgetTableViewController *budgetController = [[[BudgetTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
//    budgetController.managedObjectContext = self.managedObjectContext;
//    budgetController.isInitial = YES;
//    [self.navigationController pushViewController:budgetController animated:YES];
}

- (IBAction)runningBudgetClicked:(id)sender {
//    UITableViewCell *clickedCell = (UITableViewCell *) [[sender superview] superview];
//    NSIndexPath *indexPath = [self.mTableViewPrice indexPathForCell:clickedCell];
//    Home  *home = [fetchedResultsController objectAtIndexPath:indexPath];
//    SurplusDetailsViewController *svc = [[[SurplusDetailsViewController alloc] initWithNibName:@"SurplusDetailsViewController" bundle:nil initialSurplus:[home getInitialCapacity] runningSurplus:[home getRunningCapacity]] autorelease];
    
    SimpleSurplusViewController *svc = [[SimpleSurplusViewController alloc] initWithNibName:@"SimpleSurplusViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
    
    
//    BudgetTableViewController *budgetController = [[[BudgetTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
//    budgetController.managedObjectContext = self.managedObjectContext;
//    budgetController.isInitial = NO;
//    [self.navigationController pushViewController:budgetController animated:YES];
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
    }   
}

#pragma mark - Table view delegate

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [self.mTableView setEditing:editing animated:animated];
    [self.mTableViewPrice setEditing:editing animated:animated];
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
    [detailViewController.home populateDefaultBudgetItems];
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
    [NSFetchedResultsController deleteCacheWithName:@"Root"];  
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
    [self.mTableViewPrice beginUpdates];
}

- (void) commitChangeType:(NSFetchedResultsChangeType)type atIndexPath:(NSIndexPath *) indexPath newIndexPath:(NSIndexPath *) newIndexPath tableView:(UITableView *) tableView {
    switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
            if (tableView == self.mTableView) {
                [self configureLocationCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self configurePriceCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}

}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    //Commit change to both table views.
    [self commitChangeType:type atIndexPath:indexPath newIndexPath:newIndexPath tableView:self.mTableView];
    [self commitChangeType:type atIndexPath:indexPath newIndexPath:newIndexPath tableView:self.mTableViewPrice];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.mTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [self.mTableViewPrice insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            [self.mTableViewPrice deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.mTableView endUpdates];
    [self.mTableViewPrice endUpdates];
}


#pragma mark -


#pragma mark memory maanagement

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [scrollView release];
    [pageControl release];
    [mTableView release];
    [mTableViewPrice release];
    [super dealloc];
}

@end
