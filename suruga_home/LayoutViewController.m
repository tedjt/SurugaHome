//
//  LayoutViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LayoutViewController.h"
#import "RoomsTableViewController.h"

@implementation LayoutViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.pageTitle = NSLocalizedString(@"Moving In", @"Layout nav title");
    self.nextVC = [[[RoomsTableViewController alloc] initWithNibName:@"RoomsTableViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    self.categoryName = @"Moving In";
    self.pageDescriptionLabel.text = NSLocalizedString(@"Use this page when moving into your home. First use the checklist to get organized and plan. Then plan what furniture you will need for each room and estimate costs.", @"Furniture tab description text");
    self.checklistDetailsLabel.text = NSLocalizedString(@"Manage tasks for moving in.", @"Home Tab checklist details text");
    
    [self.imageButton setImage:[UIImage imageNamed:@"home_cross_section.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"Layout Rooms", @"Layout Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
    self.featureDetailLabel.text = NSLocalizedString(@"Plan the furniture for your home.", @"Furnish Tab Layout details text");
}

@end
