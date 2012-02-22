//
//  HomeViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewController.h"

@implementation HomeViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.pageTitle = NSLocalizedString(@"Find a Home", @"Homes list nav title");
    self.nextVC = [[[HomeTableViewController alloc] initWithNibName:@"HomeTableViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    self.categoryName = @"Find A House";
    self.pageDescriptionLabel.text = NSLocalizedString(@"Use this page when deciding on a new home. First use the checklist to get organized and plan. As you visit homes you can use My Homes to record information about each one.", @"Home tab description text");
    self.checklistDetailsLabel.text = NSLocalizedString(@"Manage tasks for finding a home", @"Home Tab checklist details text");
    [self.imageButton setImage:[UIImage imageNamed:@"home_finder.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"My Homes", @"Home Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
    self.featureDetailLabel.text = NSLocalizedString(@"Keep information about homes you visit", @"Home Tab MyHomes details text");
    
    
}

@end
