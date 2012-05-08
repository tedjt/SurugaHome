//
//  HomeMapViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeMapViewController.h"
#import "suruga_homeAppDelegate.h"
#import "Home.h"
#import "Image.h"
#import "HomeMapAnnotation.h"
#import "GoogleLocalObject.h"
#import "GTMNSString+URLArguments.h"

@implementation HomeMapViewController
@synthesize mapView;
@synthesize searchBar;
@synthesize managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (managedObjectContext == nil) { 
        self.managedObjectContext = [(suruga_homeAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    //Configure MapView
    self.mapView.delegate = self;
    
    // Add Annotations
    [self loadMapViewAnnotations];
    
    //TODO Make the mapview have the right zoom for the annotations.
    [mapView setShowsUserLocation:YES];
	[searchBar setDelegate:self];
	googleLocalConnection = [[GoogleLocalConnection alloc] initWithDelegate:self]; 
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSearchBar:nil];
    [googleLocalConnection release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [mapView release];
    [searchBar release];
    [super dealloc];
}

- (void) loadMapViewAnnotations {
    //Remove all annotations
    for (id annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]){
            [self.mapView removeAnnotation:annotation];
        }
    }
    // add annotations.
    for (Home *home in [Home fetchAllHomesWithContext: self.managedObjectContext])
    {
        if (home.address != nil && home.latitude != nil && fabs([home.latitude doubleValue]) > 0.001) {
            HomeMapAnnotation *annotation = [[[HomeMapAnnotation alloc] init] autorelease];
            annotation.title = home.name;
            annotation.subtitle = home.address;
            annotation.coordinate = [home getCoordinate];
            Image *imageObject = [home.images anyObject];
            if (imageObject != nil) {
                annotation.image = [UIImage imageWithData:imageObject.thumb];
            }
            annotation.home = home;
            [self.mapView addAnnotation:annotation];
        }
    }
}

# pragma mark Google Search Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
	[sBar resignFirstResponder];
	[googleLocalConnection getGoogleObjectsWithQuery:sBar.text andMapRegion:[mapView region] andNumberOfResults:8 addressesOnly:YES andReferer:@"http://WWW.glurban10.mit.edu"];
}

- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFinishLoadingWithGoogleLocalObjects:(NSMutableArray *)objects andViewPort:(MKCoordinateRegion)region
{
    if ([objects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matches found near this location" message:@"Try another place name or address (or move the map and try again)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else {
        id userAnnotation=mapView.userLocation;
        [mapView removeAnnotations:mapView.annotations];
        // Re add the homes.
        [self loadMapViewAnnotations];
        // add the nearby items
        [mapView addAnnotations:objects];
        if(userAnnotation!=nil)
			[mapView addAnnotation:userAnnotation];
        [mapView setRegion:region];
    }
}

- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error finding place - Try again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if  ([annotation isKindOfClass:[GoogleLocalObject class]])
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
        customPinView.pinColor = MKPinAnnotationColorGreen;
        customPinView.canShowCallout = YES;
        // Assign a callout to launch the specific home.
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

#pragma mark HomeDetailViewControllerDelegate
/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)homeDetailViewController:(HomeDetailViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		NSError *error;
		if (![self.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
    
	// Dismiss the modal view to return to the main list
    [self.navigationController popViewControllerAnimated:YES];
}
@end
