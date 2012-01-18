//
//  OneBoxTableViewController.h
//  DubbleWrapper
//
//  Created by Glen Urban on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BudgetItem.h"
#import "BudgetItemViewController.h"

@interface BudgetTableViewController : UITableViewController < UITextFieldDelegate, BudgetItemDetailDelegate>{
    NSMutableArray *costItems;
    NSMutableArray *incomeItems;
	NSManagedObjectContext *managedObjectContext;
    
    BOOL isInitial;
    
    UIBarButtonItem * doneButton;
    UITextField * activeField;
}
@property (nonatomic, retain) NSMutableArray *costItems;
@property (nonatomic, retain) NSMutableArray *incomeItems;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property BOOL isInitial;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;

@end
