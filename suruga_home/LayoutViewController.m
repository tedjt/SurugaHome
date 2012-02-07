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
    
    [self.imageButton setImage:[UIImage imageNamed:@"home_cross_section.png"] forState:UIControlStateNormal];
    NSString *title = NSLocalizedString(@"Layout Rooms", @"Layout Launcher title");
    [self.textButton setTitle:title forState:UIControlStateNormal];
    [self.textButton setTitle:title forState:UIControlStateHighlighted];
    [self.textButton setTitle:title forState:UIControlStateDisabled];
    [self.textButton setTitle:title forState:UIControlStateSelected];
}

@end
