//
//  TextFieldPickerView.h
//  suruga_home
//
//  Created by Ted Tomlinson on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) NSArray *mOptions;
// Use a weak reference to avoid a retain cycle.
@property (nonatomic, assign) UITextField *mTextField;

- (id) initWithTextField: (UITextField *) textField options: (NSArray *) options useNewButton: (BOOL) useNewButton;

@end
