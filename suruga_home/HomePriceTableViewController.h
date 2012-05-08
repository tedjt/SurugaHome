//
//  HomePriceTableViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HomeBudgetItem.h"
#import "BudgetItemViewController.h"
#import "Home.h"

@protocol HomePriceTableViewControllerDelegate;

@interface HomePriceTableViewController : UITableViewController < UITextFieldDelegate, BudgetItemDetailDelegate>{
    NSMutableArray *initialItems;
    NSMutableArray *runningItems;

    UIBarButtonItem * doneButton;
    UITextField * activeField;
    
    Home *home;
}

@property (nonatomic, retain) NSMutableArray *initialItems;
@property (nonatomic, retain) NSMutableArray *runningItems;

@property (nonatomic, retain) Home *home;
@property (nonatomic, assign) id <HomePriceTableViewControllerDelegate>parentController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;
@end

@protocol HomePriceTableViewControllerDelegate <NSObject>
- (void)updatePrice;
@end
