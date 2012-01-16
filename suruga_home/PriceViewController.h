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
    
    Price *price;
    
    id <PriceViewControllerDelegate> parentController;
    
    
}

@property (nonatomic, retain) IBOutlet UITextField *depositTextField;
@property (nonatomic, retain) IBOutlet UITextField *upfrontRentTextField;
@property (nonatomic, retain) IBOutlet UITextField *feesTextField;
@property (nonatomic, retain) IBOutlet UITextField *rentTextField;
@property (nonatomic, retain) IBOutlet UITextField *insuranceTextField;

@property (nonatomic, retain) Price *price;

@property (nonatomic, assign) id <PriceViewControllerDelegate>parentController;

@end

@protocol PriceViewControllerDelegate <NSObject>
- (void)dismissPriceViewController:(PriceViewController *)priceViewController;
@end