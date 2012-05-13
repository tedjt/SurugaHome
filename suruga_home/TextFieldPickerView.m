//
//  TextFieldPickerView.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextFieldPickerView.h"

@implementation TextFieldPickerView
@synthesize mOptions;
@synthesize mTextField;
@synthesize componentWidths;

- (id) initWithTextField: (UITextField *)textField options: (NSArray *)options useNewButton:(BOOL) useNewButton {
    
    if (!(self = [super init])) {
        return nil;
    }
    if ([[options objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        //assume 2d array is passed
        self.mOptions = options;
    } else {
        //assume its a 1 d array of options - so wrap it in another array.
        self.mOptions = [NSArray arrayWithObject:options];
    }
    self.mTextField = textField;
    self.showsSelectionIndicator = YES;
    self.dataSource = self;
    self.delegate = self;
    
    textField.inputView = self;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done Button Text") style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDone:)] autorelease];
    UIBarButtonItem* newButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New", @"New Button Text") style:UIBarButtonItemStyleBordered target:self action:@selector(pickerNew:)] autorelease];
    NSArray *keyboardItems = useNewButton ? [NSArray arrayWithObjects:doneButton, newButton, nil] : [NSArray arrayWithObject:doneButton];
    [keyboardDoneButtonView setItems:keyboardItems];
    
    // Plug the keyboardDoneButtonView into the text field...
    textField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
    
    return self;
}

- (IBAction)pickerDone:(id)sender{   
    [self.mTextField resignFirstResponder];
}

- (IBAction)pickerNew:(id)sender{   
    //TODO - change keyboard layout
    self.mTextField.inputView = nil;
    [self.mTextField resignFirstResponder];
    self.mTextField.text = nil;
    [self.mTextField becomeFirstResponder];
    // set the picker view to be the input view again on future selections
    self.mTextField.inputView = self;
}

# pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.mOptions count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.mOptions objectAtIndex:component] count];
}

# pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.mOptions objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != -1){
        NSString *joinerString = @", ";
        NSString *s = self.mTextField.text;
        NSMutableArray *sa = [NSMutableArray arrayWithArray:[s componentsSeparatedByString:joinerString]];
        // for uninitialized fields add first option to sa
        if ([sa count] < [self.mOptions count]) {
            [sa replaceObjectAtIndex:0 withObject:[[self.mOptions objectAtIndex:0] objectAtIndex: 0]];
            for (int i = 1; i < [self.mOptions count]; i++) {
                [sa addObject: [[self.mOptions objectAtIndex:i] objectAtIndex: 0]];
            }
        }
        // replace object with user's choice
        [sa replaceObjectAtIndex:component withObject:[[self.mOptions objectAtIndex:component] objectAtIndex:row]];
        
        // Set textfield text to joined array
        self.mTextField.text = [sa componentsJoinedByString:joinerString];
    }
}

- (CGFloat) pickerView: (UIPickerView *) thePickerView widthForComponent:(NSInteger)component {
    if (self.componentWidths != nil) {
        return [(NSNumber *)[componentWidths objectAtIndex:component] floatValue];
    }
    else{
        return 300.0/[self.mOptions count];
    }
}


- (void) dealloc {
    [mOptions release];
    [super dealloc];
}

@end
