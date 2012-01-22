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
@synthesize whenTextField;
@synthesize nameTextField;
@synthesize reasonTextField;
@synthesize isRentingSwitch;
@synthesize scrollView;
@synthesize dateFormatter;
@synthesize datePicker;
@synthesize userData;
/*
 {"name":"Find A House",
 "order": 1,
 "tasks": [
     {"name": "Choose a move date",
     "order": 1,},
     {"name": "Choose home size, amenities",
     "order": 2},
     {"name": "Ch
 */
#pragma mark - PRIVATE FUNCTIONS
- (void)buildStaticData
{
   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"introData" ofType:@"json"];
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

- (void)keyBoardDatePicker 
{
    // create a UIPicker view as a custom keyboard view
    self.datePicker = [[[UIDatePicker alloc] init] autorelease];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if ([self.dateFormatter dateFromString: whenTextField.text] != nil) {
        datePicker.date = [self.dateFormatter dateFromString: whenTextField.text];
    }
    whenTextField.inputView = datePicker;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneClicked:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    whenTextField.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isRentingSwitch.onText = NSLocalizedString(@"Renting", @"");
	self.isRentingSwitch.offText = NSLocalizedString(@"Buying", @"");
    
    //Setup date keyboard view
    [self keyBoardDatePicker];
    
    //Register for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillBeHidden:)
     name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setWhenTextField:nil];
    [self setReasonTextField:nil];
    [self setIsRentingSwitch:nil];
    [self setScrollView:nil];
    self.datePicker = nil;
    self.dateFormatter = nil;
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
        reasonTextField.text.length > 0 &&
        whenTextField.text.length > 0) {
        //Set field values
        self.userData.name = nameTextField.text;
        self.userData.reason = reasonTextField.text;
        self.userData.when = [self.dateFormatter dateFromString: whenTextField.text];
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
    [whenTextField release];
    [reasonTextField release];
    [isRentingSwitch release];
    [scrollView release];
    [datePicker release];
    [dateFormatter release];
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
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
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
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

#pragma mark -
#pragma mark Date Picker actions

//See KeyboardDatePicker private function.

- (void)doneClicked:(id)sender {
    whenTextField.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    [whenTextField resignFirstResponder];
}

#pragma mark -
@end
