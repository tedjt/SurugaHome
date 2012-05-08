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
@synthesize firstSlider;
@synthesize secondSlider;
@synthesize thirdSlider;
@synthesize fourthSlider;
@synthesize fifthSlider;
@synthesize sixthSlider;
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
        self.firstSlider.value = [rating.first floatValue];
        self.secondSlider.value = [rating.second floatValue];
        self.thirdSlider.value = [rating.third floatValue];
        self.fourthSlider.value = [rating.fourth floatValue];
        self.fifthSlider.value = [rating.fifth floatValue];
        self.sixthSlider.value = [rating.sixth floatValue];
        
    }
}

- (void)viewDidUnload
{
    [self setFirstSlider:nil];
    [self setSecondSlider:nil];
    [self setThirdSlider:nil];
    [self setFourthSlider:nil];
    [self setFifthSlider:nil];
    [self setSixthSlider:nil];
    self.rating = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [firstSlider release];
    [secondSlider release];
    [thirdSlider release];
    [fourthSlider release];
    [fifthSlider release];
    [sixthSlider release];
    [rating release];
    [super dealloc];
}

#pragma mark - Model Methods
- (IBAction)save:(id)sender {
    self.rating.overall = [NSNumber numberWithInteger: overallRatingControl.rating];
    self.rating.second = [NSNumber numberWithFloat:secondSlider.value];
    self.rating.third = [NSNumber numberWithFloat:thirdSlider.value];
    self.rating.fourth = [NSNumber numberWithFloat:fourthSlider.value];
    self.rating.fifth = [NSNumber numberWithFloat:fifthSlider.value];
    self.rating.sixth = [NSNumber numberWithFloat:sixthSlider.value];
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
