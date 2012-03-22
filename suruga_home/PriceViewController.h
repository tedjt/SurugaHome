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
    UITextField *rentMortgageTextField;
    UITextField *insuranceTextField;
    UIScrollView *scrollView;
    UITextField *activeField;
    NSMutableArray *textFieldArray; 
    
    Price *price;
    
    id <PriceViewControllerDelegate> parentController;
    
    UIBarButtonItem * saveButton;
    UIBarButtonItem * doneButton;
    
    
}

@property (nonatomic, retain) IBOutlet UITextField *depositTextField;
@property (nonatomic, retain) IBOutlet UITextField *upfrontRentTextField;
@property (nonatomic, retain) IBOutlet UITextField *feesTextField;
@property (nonatomic, retain) IBOutlet UITextField *rentMortgageTextField;
@property (nonatomic, retain) IBOutlet UITextField *insuranceTextField;
@property (retain, nonatomic) IBOutlet UITextField *taxesTextField;
@property (retain, nonatomic) IBOutlet UILabel *depositLabel;
@property (retain, nonatomic) IBOutlet UILabel *feesLabel;
@property (retain, nonatomic) IBOutlet UILabel *upfrontRentLabel;
@property (retain, nonatomic) IBOutlet UILabel *rentMortgageLabel;
@property (retain, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (retain, nonatomic) IBOutlet UILabel *taxesLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) Price *price;

@property (nonatomic, assign) id <PriceViewControllerDelegate>parentController;
- (IBAction)budgetButtonClicked:(id)sender;

@end

@protocol PriceViewControllerDelegate <NSObject>
- (void)dismissPriceViewController:(PriceViewController *)priceViewController;
@end