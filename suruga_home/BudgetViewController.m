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

@implementation BudgetViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"category.name == %@", @"Financial Planning"];
    self.pageTitle = NSLocalizedString(@"Budget Planning", @"Financial Planning nav title");
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
}

@end
