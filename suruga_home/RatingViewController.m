//
//  RatingViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingViewController.h"


@implementation RatingViewController
@synthesize rating;
@synthesize locationSlider;
@synthesize transportationSlider;
@synthesize parksSlider;
@synthesize foodSlider;
@synthesize sizeSlider;
@synthesize kitchenSlider;
@synthesize overallRatingControl;
@synthesize parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rating: (Rating *)theRating
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.overallRatingControl = [[[DLStarRatingControl alloc] initWithFrame:CGRectMake(37, 11, 230, 53) andStars:5] autorelease];
        self.overallRatingControl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:self.overallRatingControl];
        self.rating = theRating;
        //set up navigation Controller
        self.title = NSLocalizedString(@"Rate Home", @"Ratings details view title");
        //Nav bar buttons
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    }
    [self setRatings];
    return self;
}

#pragma mark - View lifecycle

- (void)setRatings
{
    if (self.rating != nil) {
        self.overallRatingControl.rating = [rating.overall intValue];
        self.locationSlider.value = [rating.location floatValue];
        self.transportationSlider.value = [rating.transportation floatValue];
        self.parksSlider.value = [rating.parks floatValue];
        self.foodSlider.value = [rating.food floatValue];
        self.sizeSlider.value = [rating.size floatValue];
        self.kitchenSlider.value = [rating.kitchen floatValue];
        
    }
}

- (void)viewDidUnload
{
    [self setLocationSlider:nil];
    [self setTransportationSlider:nil];
    [self setParksSlider:nil];
    [self setFoodSlider:nil];
    [self setSizeSlider:nil];
    [self setKitchenSlider:nil];
    self.rating = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [locationSlider release];
    [transportationSlider release];
    [parksSlider release];
    [foodSlider release];
    [sizeSlider release];
    [kitchenSlider release];
    [rating release];
    [super dealloc];
}

#pragma mark - Model Methods
- (IBAction)save:(id)sender {
    self.rating.overall = [NSNumber numberWithInteger: overallRatingControl.rating];
    self.rating.transportation = [NSNumber numberWithFloat:transportationSlider.value];
    self.rating.parks = [NSNumber numberWithFloat:parksSlider.value];
    self.rating.food = [NSNumber numberWithFloat:foodSlider.value];
    self.rating.size = [NSNumber numberWithFloat:sizeSlider.value];
    self.rating.kitchen = [NSNumber numberWithFloat:kitchenSlider.value];
    // Dismiss the modal view to return to the main list
    [self.parentController dismissRatingViewController:self ];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - DLStarRatingDelagate methods

- (void)newRating:(DLStarRatingControl *)control: (NSUInteger)rating {
    //pass
}
#pragma mark - 
@end
