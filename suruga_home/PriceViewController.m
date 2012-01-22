//
//  PriceViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PriceViewController.h"
#import "Price.h"

@implementation PriceViewController
@synthesize depositTextField;
@synthesize upfrontRentTextField;
@synthesize feesTextField;
@synthesize rentTextField;
@synthesize insuranceTextField;
@synthesize scrollView;
@synthesize price;
@synthesize parentController;
@synthesize saveButton, doneButton;

#pragma mark - Private Functions
- (void)setPrices
{
    if (self.price != nil) {
        self.depositTextField.text = [price.initialCost stringValue];
        self.feesTextField.text = [price.fees stringValue];
        self.rentTextField.text = [price.runningCost stringValue];
        //TODO - insurance and upfront rent && property taxes
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
    [self setPrices];
    
    //Set keyboard layout
    self.depositTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.upfrontRentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.feesTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.rentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.insuranceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
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
    [self setRentTextField:nil];
    [self setInsuranceTextField:nil];
    self.price = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [depositTextField release];
    [upfrontRentTextField release];
    [feesTextField release];
    [rentTextField release];
    [insuranceTextField release];
    [price release];
    [scrollView release];
    [super dealloc];
}
#pragma mark - Model Methods
- (IBAction)save:(id)sender {
    self.price.initialCost = [NSNumber numberWithDouble:[depositTextField.text doubleValue]];
    self.price.fees = [NSNumber numberWithDouble:[feesTextField.text doubleValue]];
    self.price.runningCost = [NSNumber numberWithDouble:[rentTextField.text doubleValue]];
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

@end
