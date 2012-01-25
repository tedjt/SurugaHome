//
//  BudgetViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetViewController.h"
#import "FinancialHomeViewController.h"
#import "Category.h"
#import "FinancialAdviceViewController.h"

@implementation BudgetViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"category.name == %@", @"Financial Planning"];
    self.pageTitle = NSLocalizedString(@"Budget Planning", @"Budget Planning Home Title");
    self.nextVC = [[[FinancialHomeViewController alloc] initWithNibName:@"FinancialHomeViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    
    self.category = [Category fetchCategoryWithName:@"Financial Planning" context:self.managedObjectContext];
    
    //Set view fields
    self.checklistLabel.text = NSLocalizedString(@"Budget plan checklist", @"budget checklist title");
    [self.imageButton setImage:[UIImage imageNamed:@"budget_icon.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"Plan Budget", @"Budget Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
    
    //Add an advisor button to this view
    //Add the icon
    CGRect buttonFrame = CGRectMake( 13, 210, 95, 70 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setImage:[UIImage imageNamed:@"advisor.png"] forState:UIControlStateNormal];
    [button addTarget:self 
        action:@selector(advisorPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    [button release];
    
    //Description Button
    UIButton *advisorDescription = [[UIButton alloc] initWithFrame: CGRectMake( 108, 219, 412, 52)];
    //Set text
    NSString *advisorTitle = NSLocalizedString(@"Advisor", @"Advisor button Title");
    [advisorDescription setTitle:advisorTitle forState:UIControlStateNormal];
    [advisorDescription setTitle:advisorTitle forState:UIControlStateHighlighted];
    advisorDescription.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    advisorDescription.titleLabel.font = [UIFont fontWithName:@"Cochin" size:32];
    [advisorDescription setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    //Set events
    [advisorDescription addTarget:self 
               action:@selector(advisorPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: advisorDescription];
    [advisorDescription release];
}

- (IBAction)advisorPressed {
    FinancialAdviceViewController * vc = [[FinancialAdviceViewController alloc] initWithNibName:@"FinancialAdviceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];	
}

@end
