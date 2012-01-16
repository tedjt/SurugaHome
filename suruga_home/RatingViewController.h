//
//  RatingViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"
#import "Rating.h"
@protocol RatingViewControllerDelegate;

@interface RatingViewController : UIViewController<DLStarRatingDelegate> {
    Rating *rating;
    
    UISlider *locationSlider;
    UISlider *transportationSlider;
    UISlider *parksSlider;
    UISlider *foodSlider;
    UISlider *sizeSlider;
    UISlider *kitchenSlider;
    DLStarRatingControl *overallRatingControl;
    
    id <RatingViewControllerDelegate> parentController;
}

@property (nonatomic, retain) Rating *rating;

@property (nonatomic, retain) IBOutlet UISlider *locationSlider;
@property (nonatomic, retain) IBOutlet UISlider *transportationSlider;
@property (nonatomic, retain) IBOutlet UISlider *parksSlider;
@property (nonatomic, retain) IBOutlet UISlider *foodSlider;
@property (nonatomic, retain) IBOutlet UISlider *sizeSlider;
@property (nonatomic, retain) IBOutlet UISlider *kitchenSlider;
@property (nonatomic, retain) DLStarRatingControl *overallRatingControl;

@property (nonatomic, assign) id <RatingViewControllerDelegate> parentController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rating: (Rating *)theRating;

- (void)setRatings;

@end

@protocol RatingViewControllerDelegate <NSObject>
- (void)dismissRatingViewController:(RatingViewController *)ratingViewController;
@end
