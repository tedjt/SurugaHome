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

@interface EditTaskItemViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UITextField *name;
    UITextField *category;
    UITextField *dueDate;
    UIDatePicker *datePicker;
    UIButton *advisorButton;
    DCRoundSwitch *completedSwitch;
    UITextView *notesTextField;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *saveButton;
    UIScrollView *scrollView;
    NSDateFormatter *dateFormatter;
    Task *task;
    id <EditTaskItemViewControllerDelegate> parentController;
    
    NSArray *categoryPickerArray;
    UIPickerView *categoryPicker;
}
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *category;
@property (nonatomic, retain) IBOutlet UITextField *dueDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker; 
@property (nonatomic, retain) IBOutlet UIButton *advisorButton;
@property (nonatomic, retain) IBOutlet DCRoundSwitch *completedSwitch;
@property (nonatomic, retain) IBOutlet UITextView *notesTextField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


@property (nonatomic, retain) Task *task;
@property (nonatomic, assign) id <EditTaskItemViewControllerDelegate>parentController;

@property(nonatomic, retain) NSArray *categoryPickerArray;
@property (nonatomic, retain) UIPickerView *categoryPicker;
@property BOOL hasNewCategory;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)advisorButtonClicked:(id)sender;
@end


@protocol EditTaskItemViewControllerDelegate
- (void)taskViewController:(EditTaskItemViewController *)controller didFinishWithSave:(BOOL)save;

@end
