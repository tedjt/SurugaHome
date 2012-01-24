//
//  LayoutViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LayoutViewController.h"
#import "RoomsTableViewController.h"
#import "Category.h"

@implementation LayoutViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"category.name == %@", @"Moving In"];
    self.pageTitle = NSLocalizedString(@"Moving In", @"Layout nav title");
    self.nextVC = [[[RoomsTableViewController alloc] initWithNibName:@"RoomsTableViewController" bundle:nil] autorelease];
    
    [super viewDidLoad];
    
    self.category = [Category fetchCategoryWithName:@"Moving In" context:self.managedObjectContext];
    [self.imageButton setImage:[UIImage imageNamed:@"home_cross_section.png"] forState:UIControlStateNormal];
    self.checklistLabel.text = NSLocalizedString(@"Moving in checklist", @"Layout checklist title");
    NSString *title = NSLocalizedString(@"Layout Rooms", @"Layout Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
}

@end
