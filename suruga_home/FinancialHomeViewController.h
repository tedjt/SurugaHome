//
//  FinancialHomeViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DCRoundSwitch;
@interface FinancialHomeViewController : UIViewController {
    NSManagedObjectContext *managedObjectContext;
    
    UILabel *initialIncomeLabel;
    UILabel *initialExpenseLabel;
    UILabel *initialTotalLabel;
    UILabel *runningIncomeLabel;
    UILabel *runningExpenseLabel;
    UILabel *runningTotalLabel;
    UIButton *runningBudgetButton;
    UIButton *inititalBudgetButton;
    UIButton *financialAdviceButton;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
    NSDictionary *adviceDict;
    int runningAmount;
    int initialAmount;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UILabel *initialIncomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *initialExpenseLabel;
@property (nonatomic, retain) IBOutlet UILabel *initialTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningIncomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningExpenseLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningTotalLabel;
@property (nonatomic, retain) IBOutlet UIButton *runningBudgetButton;
@property (retain, nonatomic) IBOutlet DCRoundSwitch *isRentingSwitch;
@property (nonatomic, retain) IBOutlet UIButton *inititalBudgetButton;
@property (nonatomic, retain) IBOutlet UIButton *financialAdviceButton;
@property (retain, nonatomic) IBOutlet UILabel *initialIncomeTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *initialExpenseTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *initialTotalTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *runningIncomeTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *runningExpenseTotalLabel;
@property (retain, nonatomic) IBOutlet UILabel *runningTotalTotalLabel;
@property (nonatomic, retain) NSDictionary *adviceDict;


- (IBAction)initialBudgetClicked:(id)sender;
- (IBAction)runningBudgetClicked:(id)sender;
- (IBAction)financialAdviceClicked:(id)sender;
- (IBAction)isRentSwitched:(id)sender;

@end
