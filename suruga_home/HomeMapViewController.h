//
//  HomeMapViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "HomeDetailViewController.h"
#import "GoogleLocalConnection.h"  

@class GoogleLocalObject;

@interface HomeMapViewController : UIViewController <MKMapViewDelegate, HomeDetailViewControllerDelegate, HomeMapViewDelegate, UISearchBarDelegate, GoogleLocalConnectionDelegate> {
    
	UISearchBar *searchBar;
	MKMapView *mapView;
	GoogleLocalConnection *googleLocalConnection;
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
