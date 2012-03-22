//
//  PriceViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PriceViewController.h"
#import "FinancialHomeViewController.h"
#import "Price.h"
#import "Home.h"

@implementation PriceViewController
@synthesize depositTextField;
@synthesize upfrontRentTextField;
@synthesize feesTextField;
@synthesize rentMortgageTextField;
@synthesize insuranceTextField;
@synthesize taxesTextField;
@synthesize depositLabel, feesLabel, upfrontRentLabel, rentMortgageLabel, insuranceLabel, taxesLabel;
@synthesize scrollView;
@synthesize price;
@synthesize parentController;
@synthesize saveButton, doneButton;

#pragma mark - Private Functions
/*
 Layout Text fields depending on whether the home is buy or rent.
*/
- (void) layoutTextFields
{
    //Set Prices regardless of rent/buy
    self.depositTextField.text = [price.deposit stringValue];
    self.feesTextField.text = [price.fees stringValue];
    self.rentMortgageTextField.text = [price.rentMortgage stringValue];
    self.insuranceTextField.text = [price.insurance stringValue];
    
    if ([self.price.home.isRent boolValue]) {
        //Set Prices
        self.upfrontRentTextField.text = [price.upfrontRent stringValue];
        //Change labels
        self.rentMortgageLabel.text = NSLocalizedString(@"Rent", @"Home Price Rent Label");
        
        //Hide Unused fields
        self.taxesLabel.hidden = YES;
        self.taxesTextField.hidden = YES;
    }
    else {
        //Set prices
        self.taxesTextField.text = [price.taxes stringValue];
        //Change labels
        self.rentMortgageLabel.text = NSLocalizedString(@"Mortgage", @"Home Price Mortgage Label");
        
        //Hide Unused fields
        self.upfrontRentLabel.hidden = YES;
        self.upfrontRentTextField.hidden = YES;
    }
    
}


#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Nav bar buttons
    self.saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    self.doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    //Set prices
    [self layoutTextFields];
    
    //Register for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillBeHidden:)
        name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidUnload
{
    [self setDepositTextField:nil];
    [self setUpfrontRentTextField:nil];
    [self setFeesTextField:nil];
    [self setRentMortgageTextField:nil];
    [self setInsuranceTextField:nil];
    self.taxesTextField = nil;
    self.depositLabel = nil;
    self.feesLabel = nil;
    self.upfrontRentLabel = nil;
    self.rentMortgageLabel = nil;
    self.insuranceLabel = nil;
    self.taxesLabel = nil;
    self.price = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    //Text Fields
    [depositTextField release];
    [upfrontRentTextField release];
    [feesTextField release];
    [rentMortgageTextField release];
    [insuranceTextField release];
    [taxesTextField release];
    //Labels
    [depositLabel release];
    [feesLabel release];
    [upfrontRentLabel release];
    [rentMortgageLabel release];
    [insuranceLabel release];
    [taxesLabel release];
    // Other objects
    [price release];
    [scrollView release];
    [super dealloc];
}
#pragma mark - Model Methods
- (IBAction)save:(id)sender {
    //Set Prices regardless of rent/buy
    self.price.deposit = [NSNumber numberWithInt:[depositTextField.text intValue]];
    self.price.fees = [NSNumber numberWithInt:[feesTextField.text intValue]];
    self.price.rentMortgage = [NSNumber numberWithInt:[rentMortgageTextField.text intValue]];
    self.price.insurance = [NSNumber numberWithInt:[insuranceTextField.text intValue]];
    //Handle rent/buy specific prices
    if ([self.price.home.isRent boolValue]) {
        self.price.upfrontRent = [NSNumber numberWithInt:[upfrontRentTextField.text intValue]];
    }
    else {
        self.price.taxes = [NSNumber numberWithInt:[taxesTextField.text intValue]];
    }
    // Dismiss the modal view to return to the main list
    [self.parentController dismissPriceViewController:self ];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbFrame.size.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbFrame.size.height;
    if (!CGRectContainsPoint(aRect, CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y + activeField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0,activeField.frame.origin.y + activeField.frame.size.height - (self.view.frame.size.height-kbFrame.size.height));
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

- (IBAction)done:(id)sender {
    [activeField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}
#pragma mark -
#pragma mark -

- (IBAction)budgetButtonClicked:(id)sender {
    FinancialHomeViewController *budgetView = [[FinancialHomeViewController alloc] initWithNibName:@"FinancialHomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:budgetView animated:YES];
    [budgetView release];
}
@end
