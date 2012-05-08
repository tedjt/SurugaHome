//
//  HomeDetailViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RatingViewController.h"
#import "HomePriceTableViewController.h"
#import "SVGeocoder.h"

@class Home;
@class DCRoundSwitch;
@protocol HomeDetailViewControllerDelegate;


@interface HomeDetailViewController : UIViewController <RatingViewControllerDelegate, HomePriceTableViewControllerDelegate, SVGeocoderDelegate, UITextFieldDelegate> {
    Home *home;
    id <HomeDetailViewControllerDelegate> parentController;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *addressTextField;
    UITextField *activeField;
    MKMapView *mapView;
    UIButton *imageButton;
    UIButton *ratingButton;
    UIButton *priceButton;
}

@property (nonatomic, retain) Home *home;
@property (nonatomic, assign) id <HomeDetailViewControllerDelegate>parentController;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (retain, nonatomic) IBOutlet UITextField *sizeTextField;
@property (retain, nonatomic) IBOutlet UITextField *layoutTextField;
@property (retain, nonatomic) IBOutlet UITextField *stationTextField;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *imageButton;
@property (nonatomic, retain) IBOutlet UIButton *ratingButton;
@property (nonatomic, retain) IBOutlet UIButton *priceButton;
@property (retain, nonatomic) IBOutlet UITextView *notesTextField;
@property (retain, nonatomic) IBOutlet DCRoundSwitch *isRentSwitch;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)ratingButtonClicked:(id)sender;
- (IBAction)priceButtonClicked:(id)sender;
- (IBAction)isRentSwitched:(id)sender;

- (void) updateHomeObject;
- (void) setMapViewZoom;

@end

@protocol HomeDetailViewControllerDelegate
- (void)homeDetailViewController:(HomeDetailViewController *)controller didFinishWithSave:(BOOL)save;
@end

@protocol HomeMapViewDelegate
- (void) loadMapViewAnnotations;

@end