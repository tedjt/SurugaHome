//
//  EditTaskItemViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@class Task;

@protocol EditTaskItemViewControllerDelegate;

@interface EditTaskItemViewController : UIViewController {
    UITextField *name;
    UITextField *category;
    UITextField *dueDate;
    UIDatePicker *datePicker;
    DCRoundSwitch *completedSwitch;
    NSDateFormatter *dateFormatter;
    Task *task;
    id <EditTaskItemViewControllerDelegate> parentController;
}
@property (nonatomic, assign) BOOL isNewTask;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *category;
@property (nonatomic, retain) IBOutlet UITextField *dueDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker; 
@property (nonatomic, retain) IBOutlet DCRoundSwitch *completedSwitch;


@property (nonatomic, retain) Task *task;
@property (nonatomic, assign) id <EditTaskItemViewControllerDelegate>parentController;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end


@protocol EditTaskItemViewControllerDelegate
- (void)taskViewController:(EditTaskItemViewController *)controller didFinishWithSave:(BOOL)save;

@end
