//
//  HomeTableViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "HomeDetailViewController.h"

@interface HomeTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, HomeDetailViewControllerDelegate, UIScrollViewDelegate> {
    
    NSFetchedResultsController *fetchedResultsController;
    UIScrollView *scrollView;
    NSManagedObjectContext *managedObjectContext;
    
    UIPageControl *pageControl;
    UITableView *mTableView;
    UITableView *mTableViewPrice;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UITableView *mTableViewPrice;

- (void)configureLocationCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)configurePriceCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)addHome;
- (IBAction)changePage:(id)sender;
@end
