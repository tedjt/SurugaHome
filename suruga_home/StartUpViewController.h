//
//  StartUpViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"
#import "UserData.h"

@interface StartUpViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UITextField *nameTextField;
    UITextField *reasonTextField;
    DCRoundSwitch *isRentingSwitch;
    UIScrollView *scrollView;
    UITextField *whenTextField;
    UITextField *activeField;
    
    NSDateFormatter *dateFormatter;
    UIDatePicker *datePicker;
    
    NSArray *reasonPickerArray;
    UIPickerView *reasonPicker;
    
    
    UserData *userData;
}
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *whenTextField;
@property (nonatomic, retain) IBOutlet UITextField *reasonTextField;
@property (nonatomic, retain) IBOutlet DCRoundSwitch *isRentingSwitch;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *reasonPicker;
@property (nonatomic, retain) NSArray *reasonPickerArray;


@property (nonatomic, retain) UserData *userData;

- (IBAction)registerButtonClicked:(id)sender;

@end
