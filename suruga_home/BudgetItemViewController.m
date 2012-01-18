//
//  BudgetItemViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetItemViewController.h"
#import "BudgetItem.h"

@implementation BudgetItemViewController
@synthesize nameTextField;
@synthesize amountTextField;
@synthesize notesLabel;
@synthesize item;
@synthesize parentController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (item.name != nil) {
        self.title = item.name;
    }
    //Nav bar buttons
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    
    // Set Text field values
    nameTextField.text = item.name;
    amountTextField.text = [item.amount stringValue];
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    notesLabel.text = item.notes;
    [notesLabel sizeToFit];
    
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setAmountTextField:nil];
    [self setNotesLabel:nil];
    self.item = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [nameTextField release];
    [amountTextField release];
    [notesLabel release];
    [item release];
    [super dealloc];
}

#pragma mark - Model Methods
- (IBAction)save:(id)sender {
    self.item.name = nameTextField.text;
    self.item.amount = [NSNumber numberWithDouble:[amountTextField.text doubleValue]];
    //Save
    [self.parentController budgetItemViewController:self didFinishWithSave:YES];
}

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
