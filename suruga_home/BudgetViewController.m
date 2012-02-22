//
//  BudgetViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetViewController.h"
#import "FinancialHomeViewController.h"
#import "FinancialAdviceViewController.h"

@implementation BudgetViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.pageTitle = NSLocalizedString(@"Budget Planning", @"Budget Planning Home Title");
    self.nextVC = [[[FinancialHomeViewController alloc] initWithNibName:@"FinancialHomeViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    
    self.categoryName = @"Financial Planning";
    self.pageDescriptionLabel.text = NSLocalizedString(@"Use this page when budget planning your move. First use the checklist to get organized and plan. Then use the budget function to estimate long and short term costs after your move. The Advisor function can help you make financial decisions like savings or loans.", @"Financial tab description text");
    self.checklistDetailsLabel.text = NSLocalizedString(@"Manage tasks for budget planning", @"Financial Tab checklist details text");
    
    //Set view fields
    [self.imageButton setImage:[UIImage imageNamed:@"budget_icon.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"Plan Budget", @"Budget Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
    self.featureDetailLabel.text = NSLocalizedString(@"Plan your budget", @"Financial Tab Layout Budget details text");
    
    //Add an advisor button to this view
    //Add the icon
    CGRect buttonFrame = CGRectMake( 13, 277, 95, 70 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setImage:[UIImage imageNamed:@"advisor.png"] forState:UIControlStateNormal];
    [button addTarget:self 
        action:@selector(advisorPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    [button release];
    
    //Description Button
    UIButton *advisorDescription = [[UIButton alloc] initWithFrame: CGRectMake( 108, 287, 412, 52)];
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
    //Details label.
    UILabel *advisorDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 332, 194, 20)];
    advisorDetailsLabel.minimumFontSize = 10.;
    advisorDetailsLabel.adjustsFontSizeToFitWidth = YES;
    advisorDetailsLabel.backgroundColor = [UIColor clearColor];
    advisorDetailsLabel.lineBreakMode = UILineBreakModeWordWrap;
    advisorDetailsLabel.numberOfLines = 1;
    advisorDetailsLabel.text = NSLocalizedString(@"Get financial advice", @"Financial Tab Advisor details text");
    advisorDetailsLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [self.view addSubview:advisorDetailsLabel];
    [advisorDetailsLabel release];
}

- (IBAction)advisorPressed {
    FinancialAdviceViewController * vc = [[FinancialAdviceViewController alloc] initWithNibName:@"FinancialAdviceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];	
}

@end
