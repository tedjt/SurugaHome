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
    
    UISlider *firstSlider;
    UISlider *secondSlider;
    UISlider *thirdSlider;
    UISlider *fourthSlider;
    UISlider *fifthSlider;
    UISlider *sixthSlider;
    DLStarRatingControl *overallRatingControl;
    
    id <RatingViewControllerDelegate> parentController;
}

@property (nonatomic, retain) Rating *rating;

@property (nonatomic, retain) IBOutlet UISlider *firstSlider;
@property (nonatomic, retain) IBOutlet UISlider *secondSlider;
@property (nonatomic, retain) IBOutlet UISlider *thirdSlider;
@property (nonatomic, retain) IBOutlet UISlider *fourthSlider;
@property (nonatomic, retain) IBOutlet UISlider *fifthSlider;
@property (nonatomic, retain) IBOutlet UISlider *sixthSlider;
@property (nonatomic, retain) DLStarRatingControl *overallRatingControl;

@property (nonatomic, assign) id <RatingViewControllerDelegate> parentController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rating: (Rating *)theRating;

- (void)setRatings;

@end

@protocol RatingViewControllerDelegate <NSObject>
- (void)dismissRatingViewController:(RatingViewController *)ratingViewController;
@end
