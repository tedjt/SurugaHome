//
//  BudgetItemViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetItem;
@protocol BudgetItemDetailDelegate;

@interface BudgetItemViewController : UIViewController <UITextFieldDelegate> {
    UITextField *nameTextField;
    UITextField *amountTextField;
    UILabel *notesLabel;
    
    BudgetItem *item;
    
    id <BudgetItemDetailDelegate> parentController;
}


@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *amountTextField;
@property (nonatomic, retain) IBOutlet UILabel *notesLabel;
@property (nonatomic, retain) BudgetItem *item;
@property (nonatomic, assign) id <BudgetItemDetailDelegate>parentController;
@end

@protocol BudgetItemDetailDelegate
- (void)budgetItemViewController:(BudgetItemViewController *)controller didFinishWithSave:(BOOL)save;

@end
