//
//  StartUpViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartUpViewController.h"
#import "suruga_homeAppDelegate.h"
#import "extThree20JSON/SBJson.h"
#import "Category.h"
#import "Task.h"
#import "BudgetItem.h"
#import "Room.h"
#import "Furniture.h"

@implementation StartUpViewController
@synthesize nameTextField;
@synthesize reasonTextField;
@synthesize layoutTextField;
@synthesize isRentingSwitch;
@synthesize scrollView;
@synthesize userData;
@synthesize reasonPicker;
@synthesize reasonPickerArray;
@synthesize layoutPicker;
@synthesize layoutPickerArray;

//TODO - update user data for bedroom/bathroom preference

#pragma mark - PRIVATE FUNCTIONS
- (void)buildStaticData
{
   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"introData_jp" ofType:@"json"];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *results = [fileContent JSONValue];
	
    //Tasks
	NSArray *categories = [results objectForKey:@"categories"];
    for (NSDictionary *category in categories) {
        Category *c =(Category*) [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.userData.managedObjectContext];
        
        c.order = [NSNumber numberWithInt:[[category objectForKey:@"order"] intValue]];
        c.name = [category objectForKey:@"name"];
        NSArray *tasks = [category objectForKey:@"tasks"];
        for (NSDictionary *task in tasks) {
            Task *t =(Task*) [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.userData.managedObjectContext];
            
            t.name = [task objectForKey:@"name"];
            t.advisorUrl = [task objectForKey:@"advisor_url"];
            t.order = [NSNumber numberWithInt:[[task objectForKey:@"order"] intValue]];
            t.category = c;
        }
    }
    
    //Budget Items
    NSArray *budgetItems = [results objectForKey:@"budget_items"];
    for (NSDictionary *item in budgetItems) {
        BudgetItem *b =(BudgetItem*) [NSEntityDescription insertNewObjectForEntityForName:@"BudgetItem" inManagedObjectContext:self.userData.managedObjectContext];
        
        b.name = [item objectForKey:@"name"];
        b.advisorUrl = [item objectForKey:@"advisor_url"];
        b.notes = [item objectForKey:@"notes"]; 
        b.amount = [NSNumber numberWithInt:[[item objectForKey:@"amount"] intValue]];
        b.isExpense = [NSNumber numberWithInt:[[item objectForKey:@"isExpense"] intValue]];
        b.inInitialBudget = [NSNumber numberWithInt:[[item objectForKey:@"inInitialBudget"] intValue]];
    }
    
    //Rooms
    //Tasks
	NSArray *rooms = [results objectForKey:@"rooms"];
    for (NSDictionary *room in rooms) {
        Room *r =(Room*) [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.userData.managedObjectContext];
        //TODO - add in room icons
        r.name = [room objectForKey:@"name"];
        r.type = [room objectForKey:@"type"];
        NSArray *furniture = [room objectForKey:@"furniture"];
        for (NSDictionary *item in furniture) {
            Furniture *f =(Furniture*) [NSEntityDescription insertNewObjectForEntityForName:@"Furniture" inManagedObjectContext:self.userData.managedObjectContext];
            
            f.name = [item objectForKey:@"name"];
            f.type = [item objectForKey:@"type"];
            f.price = [NSNumber numberWithInt:[[item objectForKey:@"price"] intValue]];
            f.room = r;
        }
    }
    //Homes
}

#pragma mark - PRIVATE FUNCTIONS
- (void)keyBoardReasonPicker 
{
    self.reasonPickerArray = [NSArray arrayWithObjects:
                            NSLocalizedString(@"Marriage", @"marriage reason picker choice"),
                            NSLocalizedString(@"Birth of a Child",@"child reason picker choice"),
                            NSLocalizedString(@"Job Change",@"Job change reason picker choice"),
                            NSLocalizedString(@"Current Room is small",@"small room reason picker choice"),
                            NSLocalizedString(@"University",@"University Reason Picker Choice"),
                            NSLocalizedString(@"Independence",@"Independence Reason picker choice"),
                            nil];
    //TODO - make this work for Type Category selection.
    // create a UIPicker view as a custom keyboard view
    self.reasonPicker = [[[UIPickerView alloc] init] autorelease];
    self.reasonPicker.showsSelectionIndicator = YES;
    reasonPicker.dataSource = self;
    reasonPicker.delegate = self;
    //TODO - initialize the typePicker fields from typeArray.
    
    //Set typePicker as the inputView for textFieldType
    reasonTextField.inputView = self.reasonPicker;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done Button Text") style:UIBarButtonItemStyleBordered target:self action:@selector(reasonPickerDone:)] autorelease];
    UIBarButtonItem* newButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New", @"New Button Text") style:UIBarButtonItemStyleBordered target:self action:@selector(reasonPickerNew:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, newButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    reasonTextField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}
- (void)keyBoardLayoutPicker 
{
    self.layoutPickerArray = [NSArray arrayWithObjects:
                              [NSArray arrayWithObjects:
                                NSLocalizedString(@"0 Baths", @"0 Baths"),
                                NSLocalizedString(@"1 Baths", @"1 Baths"),
                                NSLocalizedString(@"2 Baths", @"2 Baths"),
                                NSLocalizedString(@"3 Baths", @"3 Baths"),
                                  nil],
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"0 Bedrooms", @"0 Bedrooms"),
                               NSLocalizedString(@"1 Bedrooms", @"1 Bedrooms"),
                               NSLocalizedString(@"2 Bedrooms", @"2 Bedrooms"),
                               NSLocalizedString(@"3 Bedrooms", @"3 Bedrooms"),
                               nil], 
                            nil];
    //TODO - make this work for Type Category selection.
    // create a UIPicker view as a custom keyboard view
    self.layoutPicker = [[[UIPickerView alloc] init] autorelease];
    self.layoutPicker.showsSelectionIndicator = YES;
    layoutPicker.dataSource = self;
    layoutPicker.delegate = self;
    //TODO - initialize the typePicker fields from typeArray.
    
    //Set typePicker as the inputView for textFieldType
    layoutTextField.inputView = self.layoutPicker;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done Button Text") style:UIBarButtonItemStyleBordered target:self action:@selector(layoutPickerDone:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    layoutTextField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}

- (IBAction)reasonPickerDone:(id)sender{   
    [self.reasonTextField resignFirstResponder];
}
- (IBAction)reasonPickerNew:(id)sender{   
    //TODO - change keyboard layout
    reasonTextField.inputView = nil;
    [reasonTextField resignFirstResponder];
    reasonTextField.text = nil;
    [reasonTextField becomeFirstResponder];
    reasonTextField.inputView = self.reasonPicker;
}

- (IBAction)layoutPickerDone:(id)sender{   
    [self.layoutTextField resignFirstResponder];
}

# pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.reasonPicker) {
        return 1;
    }
    else if (pickerView == self.layoutPicker) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.reasonPicker) {
        return [self.reasonPickerArray count];
    }
    else if (pickerView == self.layoutPicker) {
        return [[self.layoutPickerArray objectAtIndex:component] count];
    }
    else {
        return 0;
    }
}

# pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView == self.reasonPicker) {
        return [reasonPickerArray objectAtIndex:row];
    }
    else if (thePickerView == self.layoutPicker) {
        return [[self.layoutPickerArray objectAtIndex:component] objectAtIndex:row];
    }
    else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != -1){
        if (thePickerView == self.reasonPicker) {
            self.userData.reason =  [reasonPickerArray objectAtIndex:row];
            self.reasonTextField.text = [reasonPickerArray objectAtIndex:row];
            self.reasonPicker.tag = row;
        }
        else if (thePickerView == self.layoutPicker) {
            if (component == 0) {
                self.userData.numBaths = [NSNumber numberWithInt: row];
                layoutTextField.text = [NSString stringWithFormat:@"%@, %@",[[self.layoutPickerArray objectAtIndex:0] objectAtIndex:row], [[self.layoutPickerArray objectAtIndex:1] objectAtIndex:[userData.numBeds intValue]]];
            }
            else {
                self.userData.numBeds = [NSNumber numberWithInt: row];
                layoutTextField.text = [NSString stringWithFormat:@"%@, %@",[[self.layoutPickerArray objectAtIndex:0] objectAtIndex:[userData.numBaths intValue]], [[self.layoutPickerArray objectAtIndex:1] objectAtIndex:row]];
            }
            self.layoutPicker.tag = row;
//            
//            NSArray* ta = [layoutTextField.text componentsSeparatedByString: @", "];
//            if (ta.count > 1) {
//                if (component == 0 ) {
//                    layoutTextField.text = [NSString stringWithFormat:@"%@, %@",[[self.layoutPickerArray objectAtIndex:0] objectAtIndex:row], [ta objectAtIndex:1]];
//                }
//                else {
//                    layoutTextField.text = [NSString stringWithFormat:@"%@, %@",[ta objectAtIndex:0], [[self.layoutPickerArray objectAtIndex:1] objectAtIndex:row]];
//                }
//            }
//            else {
//                layoutTextField.text = [NSString stringWithFormat:@"%@, %@",[[self.layoutPickerArray objectAtIndex:0] objectAtIndex:(component == 0 ? row : 0)], [[self.layoutPickerArray objectAtIndex:1] objectAtIndex:(component == 1 ? row : 0)]];
//            }
//            self.layoutPicker.tag = row;
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isRentingSwitch.onText = NSLocalizedString(@"Renting", @"Renting Option");
	self.isRentingSwitch.offText = NSLocalizedString(@"Buying", @"Buying Option");
    
    //Setup date keyboard view
    [self keyBoardReasonPicker];
    [self keyBoardLayoutPicker];
    
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 1300);
    
    //Register for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillBeHidden:)
     name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setReasonTextField:nil];
    [self setIsRentingSwitch:nil];
    [self setScrollView:nil];
    [self setLayoutTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerButtonClicked:(id)sender {
    //TODO - animate flip over to tab bar view
    if (nameTextField.text.length > 0 &&
        reasonTextField.text.length > 0) {
        //Set field values
        self.userData.name = nameTextField.text;
        self.userData.reason = reasonTextField.text;
        self.userData.isRenting = [NSNumber numberWithBool:isRentingSwitch.on];
        
        [self buildStaticData];

        NSError *error;
        if (![self.userData.managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        // Animate the transition
        suruga_homeAppDelegate *delegate = (suruga_homeAppDelegate *) [[UIApplication sharedApplication] delegate];
        [UIView transitionWithView:delegate.window duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            delegate.window.rootViewController = delegate.tabBarController;
        } completion:nil];
    }
    else {
        //TODO pop up a text box asking for validation
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incomplete Registration", @"Home View validation alert dialog title") 
        message:NSLocalizedString(@"You must fill in User data", @"Home View validation alert dialog")
            delegate:nil 
        cancelButtonTitle:NSLocalizedString(@"OK", @"dialog OK text")
            otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)dealloc {
    [nameTextField release];
    [reasonTextField release];
    [isRentingSwitch release];
    [scrollView release];
    [layoutTextField release];
    [super dealloc];
}

#pragma mark - Keyboard events

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y + activeField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height + 100);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}
#pragma mark -

@end
