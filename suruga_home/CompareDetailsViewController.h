//
//  CompareDetailsViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CompareDetailsViewController: UIViewController <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    //Details view elements
    UIImageView *detailsImageView;
    UITextField *detailsNameField;
    UITextField *detailsPhoneField;
    UITextField *detailsCityField;
    UITextField *detailsStateField;
    UITextField *detailsZipField;
    UITextField *detailsStreetField;
    MKMapView *detailsMapView;
    UIView *detailsView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, retain) IBOutlet UITextField *detailsNameField;
@property (nonatomic, retain) IBOutlet UITextField *detailsPhoneField;
@property (nonatomic, retain) IBOutlet UITextField *detailsCityField;
@property (nonatomic, retain) IBOutlet UITextField *detailsStateField;
@property (nonatomic, retain) IBOutlet UITextField *detailsZipField;
@property (nonatomic, retain) IBOutlet UITextField *detailsStreetField;
@property (nonatomic, retain) IBOutlet MKMapView *detailsMapView;
@property (nonatomic, retain) IBOutlet UIView *detailsView;

- (IBAction)changePage:(id)sender;

@end
