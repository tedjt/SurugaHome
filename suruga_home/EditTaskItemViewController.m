//
//  EditTaskItemViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditTaskItemViewController.h"
#import "Task.h"
#import "Category.h"

@implementation EditTaskItemViewController
@synthesize completedSwitch, name, category, dueDate, datePicker, dateFormatter, task, parentController, categoryPickerArray, categoryPicker, hasNewCategory;

#pragma mark - PRIVATE FUNCTIONS
- (void)keyBoardDatePicker 
{
    // create a UIPicker view as a custom keyboard view
    self.datePicker = [[[UIDatePicker alloc] init] autorelease];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if ([self.dateFormatter dateFromString: dueDate.text] != nil) {
        self.datePicker.date = [self.dateFormatter dateFromString: dueDate.text];
    }
    dueDate.inputView = datePicker;
    
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
    dueDate.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}

#pragma mark - PRIVATE FUNCTIONS
- (void)keyBoardCategoryPicker 
{
    self.categoryPickerArray = [Category fetchCategoriesWithContext:self.task.managedObjectContext];
    //TODO - make this work for Type Category selection.
    // create a UIPicker view as a custom keyboard view
    self.categoryPicker = [[[UIPickerView alloc] init] autorelease];
    self.categoryPicker.showsSelectionIndicator = YES;
    categoryPicker.dataSource = self;
    categoryPicker.delegate = self;
    //TODO - initialize the typePicker fields from typeArray.
    
    //Set typePicker as the inputView for textFieldType
    category.inputView = self.categoryPicker;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(categoryPickerDone:)] autorelease];
    UIBarButtonItem* newButton = [[[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(categoryPickerNew:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, newButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    category.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}
- (IBAction)categoryPickerDone:(id)sender{   
    [self.category resignFirstResponder];
}
- (IBAction)categoryPickerNew:(id)sender{   
    //TODO - change keyboard layout
    self.hasNewCategory = YES;
    category.inputView = nil;
    [category resignFirstResponder];
    category.text = nil;
    [category becomeFirstResponder];
    category.inputView = self.categoryPicker;
}

# pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.categoryPickerArray count];
}

# pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [(Category *)[categoryPickerArray objectAtIndex:row] valueForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row != -1){
        self.hasNewCategory = NO;
        self.task.category =  [categoryPickerArray objectAtIndex:row];
        self.category.text = [(Category *)[categoryPickerArray objectAtIndex:row] valueForKey:@"name"];
        self.categoryPicker.tag = row;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Rename switch view fields
    self.completedSwitch.onText = NSLocalizedString(@"Completed", @"Completed Switch on text");
	self.completedSwitch.offText = NSLocalizedString(@"In Progress", @"Completed Switch Off Text");
    
    // Do any additional setup after loading the view from its nib.
    if(self.task.name != nil) {
        self.title = self.task.name;
        self.name.text = self.task.name;
    } else { self.title = @"New Task";}
    if(self.task.category != nil) {
        self.category.text = self.task.category.name;
    }
    if(self.task.dueDate != nil) {
        self.dueDate.text = [self.dateFormatter stringFromDate: self.task.dueDate];
    }
    self.completedSwitch.on = [self.task.completed intValue] != 0;
    //self.title = self.task.name;//@"New Task";
    [self keyBoardDatePicker];
    [self keyBoardCategoryPicker];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    
    self.editing = YES;

}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setCategory:nil];
    [self setDueDate:nil];
    [self setCompletedSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    dueDate.text = [self.dateFormatter stringFromDate:self.datePicker.date];
    [dueDate resignFirstResponder];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	[parentController taskViewController:self didFinishWithSave:NO];
}

- (IBAction)save:(id)sender {
    self.task.name = name.text;
    if (self.hasNewCategory) {
        self.task.category = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:task.managedObjectContext];
        self.task.category.name = category.text;
        self.task.category.order = [NSNumber numberWithInt:([[self.categoryPickerArray valueForKeyPath:@"@max.order"] intValue] + 1)];
    }
    self.task.dueDate = [self.dateFormatter dateFromString: dueDate.text];
    self.task.completed =  [NSNumber numberWithBool: completedSwitch.on];
    [parentController taskViewController:self didFinishWithSave:YES];
}

- (void)dealloc {
    [name release];
    [category release];
    [dueDate release];
    [datePicker release];
    [dateFormatter release];
    [task release];
    [completedSwitch release];
    [super dealloc];
}
@end
