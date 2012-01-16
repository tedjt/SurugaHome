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
@synthesize price;
@synthesize parentController;

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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    //Set prices
    [self setPrices];
    
    //Set keyboard layout
    self.depositTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.upfrontRentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.feesTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.rentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.insuranceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
}

- (void)viewDidUnload
{
    [self setDepositTextField:nil];
    [self setUpfrontRentTextField:nil];
    [self setFeesTextField:nil];
    [self setRentTextField:nil];
    [self setInsuranceTextField:nil];
    self.price = nil;
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
#pragma mark -

@end
