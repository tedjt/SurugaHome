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
    UITextField *layoutTextField;
    DCRoundSwitch *isRentingSwitch;
    UIScrollView *scrollView;
    UITextField *activeField;
    
    NSArray *reasonPickerArray;
    UIPickerView *reasonPicker;
    
    NSArray *layoutPickerArray;
    UIPickerView *layoutPicker;
    
    NSArray *sizePickerArray;
    UIPickerView *sizePicker;
    
    UserData *userData;
}
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *reasonTextField;
@property (nonatomic, retain) IBOutlet UITextField *layoutTextField;
@property (retain, nonatomic) IBOutlet UITextField *sizeTextField;
@property (nonatomic, retain) IBOutlet DCRoundSwitch *isRentingSwitch;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) UIPickerView *reasonPicker;
@property (nonatomic, retain) NSArray *reasonPickerArray;
@property (nonatomic, retain) UIPickerView *layoutPicker;
@property (nonatomic, retain) NSArray *layoutPickerArray;
@property (nonatomic, retain) UIPickerView *sizePicker;
@property (nonatomic, retain) NSArray *sizePickerArray;


@property (nonatomic, retain) UserData *userData;

- (IBAction)registerButtonClicked:(id)sender;

@end
