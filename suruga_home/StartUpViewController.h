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

@interface StartUpViewController : UIViewController <UITextFieldDelegate> {
    UITextField *nameTextField;
    UITextField *reasonTextField;
    UIScrollView *scrollView;
    UITextField *activeField;
    
    UserData *userData;
}
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *reasonTextField;
@property (retain, nonatomic) IBOutlet UITextField *sizeTextField;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


@property (nonatomic, retain) UserData *userData;

- (IBAction)registerButtonClicked:(id)sender;

@end
