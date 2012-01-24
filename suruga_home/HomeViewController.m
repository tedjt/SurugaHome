//
//  HomeViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewController.h"
#import "Category.h"

@implementation HomeViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"category.name == %@", @"Find A House"];
    self.pageTitle = NSLocalizedString(@"Find a Home", @"Homes list nav title");
    self.nextVC = [[[HomeTableViewController alloc] initWithNibName:@"HomeTableViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    
    self.category = [Category fetchCategoryWithName:@"Find A House" context:self.managedObjectContext];
    self.checklistLabel.text = NSLocalizedString(@"Find a Home Checklist", @"Homes list checklist title");
    [self.imageButton setImage:[UIImage imageNamed:@"home_finder.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"My Homes", @"Home Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
}

@end
