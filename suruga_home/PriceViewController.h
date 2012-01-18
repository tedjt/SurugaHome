//
//  PriceViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Price;
@protocol PriceViewControllerDelegate;

@interface PriceViewController : UIViewController <UITextFieldDelegate> {
    UITextField *depositTextField;
    UITextField *upfrontRentTextField;
    UITextField *feesTextField;
    UITextField *rentTextField;
    UITextField *insuranceTextField;
    UIScrollView *scrollView;
    UITextField *activeField;
    
    Price *price;
    
    id <PriceViewControllerDelegate> parentController;
    
    UIBarButtonItem * saveButton;
    UIBarButtonItem * doneButton;
    
    
}

@property (nonatomic, retain) IBOutlet UITextField *depositTextField;
@property (nonatomic, retain) IBOutlet UITextField *upfrontRentTextField;
@property (nonatomic, retain) IBOutlet UITextField *feesTextField;
@property (nonatomic, retain) IBOutlet UITextField *rentTextField;
@property (nonatomic, retain) IBOutlet UITextField *insuranceTextField;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) Price *price;

@property (nonatomic, assign) id <PriceViewControllerDelegate>parentController;

@end

@protocol PriceViewControllerDelegate <NSObject>
- (void)dismissPriceViewController:(PriceViewController *)priceViewController;
@end