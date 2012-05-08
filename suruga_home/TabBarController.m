//
//  TabBarController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"suruga://comparisonTab",
                      @"suruga://budgetTab",
                      @"suruga://mapTab",
                      @"suruga://guideTab",
                      nil]];
    
    NSArray *tabs =  [self viewControllers];
    
    UIViewController *comparison = [tabs objectAtIndex:0];
    comparison.tabBarItem.image = [UIImage imageNamed:@"tab_home_finder.png"];
    comparison.tabBarItem.title = NSLocalizedString(@"Compare", @"Comparsion Tab Tite");
    
    UIViewController *budget = [tabs objectAtIndex:1];
    budget.tabBarItem.image = [UIImage imageNamed:@"tab_budget_icon.png"];
    budget.tabBarItem.title = NSLocalizedString(@"Budget", @"Budget Tab Tite");
    
    UIViewController *map = [tabs objectAtIndex:2];
    map.tabBarItem.image = [UIImage imageNamed:@"tab_move_in.png"];
    map.tabBarItem.title = NSLocalizedString(@"Map", @"Map Tab Tite");
    
    UIViewController *guide = [tabs objectAtIndex:3];
    guide.tabBarItem.image = [UIImage imageNamed:@"tab_checklist.png"];
    guide.tabBarItem.title = NSLocalizedString(@"Guide", @"Guide Tab Tite");
}
@end
