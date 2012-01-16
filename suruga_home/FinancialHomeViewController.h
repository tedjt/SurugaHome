//
//  FinancialHomeViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

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
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UILabel *initialIncomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *initialExpenseLabel;
@property (nonatomic, retain) IBOutlet UILabel *initialTotalLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningIncomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningExpenseLabel;
@property (nonatomic, retain) IBOutlet UILabel *runningTotalLabel;
@property (nonatomic, retain) IBOutlet UIButton *runningBudgetButton;
@property (nonatomic, retain) IBOutlet UIButton *inititalBudgetButton;
@property (nonatomic, retain) IBOutlet UIButton *financialAdviceButton;

- (IBAction)initialBudgetClicked:(id)sender;
- (IBAction)runningBudgetClicked:(id)sender;
- (IBAction)financialAdviceClicked:(id)sender;

@end
