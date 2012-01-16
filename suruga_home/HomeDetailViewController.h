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
#import "PriceViewController.h"
#import "SVGeocoder.h"

@class Home;
@protocol HomeDetailViewControllerDelegate;

@interface HomeDetailViewController : UIViewController <RatingViewControllerDelegate, PriceViewControllerDelegate, SVGeocoderDelegate, UITextFieldDelegate> {
    Home *home;
    id <HomeDetailViewControllerDelegate> parentController;
    UITextField *nameTextField;
    UITextField *cityTextField;
    UITextField *stateTextField;
    UITextField *zipTextField;
    UITextField *phoneTextField;
    UITextField *streetTextField;
    MKMapView *mapView;
    UIButton *imageButton;
    UIButton *ratingButton;
    UIButton *priceButton;
}

@property (nonatomic, retain) Home *home;
@property (nonatomic, assign) id <HomeDetailViewControllerDelegate>parentController;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField *streetTextField;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *imageButton;
@property (nonatomic, retain) IBOutlet UIButton *ratingButton;
@property (nonatomic, retain) IBOutlet UIButton *priceButton;

- (IBAction)textFieldOutside:(id)sender; //Deprecated function

- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)ratingButtonClicked:(id)sender;
- (IBAction)priceButtonClicked:(id)sender;

- (void) updateHomeObject;
- (void) setMapViewZoom;

@end

@protocol HomeDetailViewControllerDelegate
- (void)homeDetailViewController:(HomeDetailViewController *)controller didFinishWithSave:(BOOL)save;

- (void) loadMapViewAnnotations;

@end