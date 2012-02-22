//
//  HomeLaunchViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeLaunchViewController.h"
#import "suruga_homeAppDelegate.h"
#import "Task.h"
#import "TaskTableViewController.h"

@implementation HomeLaunchViewController
@synthesize imageButton;
@synthesize textButton;
@synthesize pageDescriptionLabel;
@synthesize checklistDetailsLabel;
@synthesize featureDetailLabel;

//conifigurable
@synthesize pageTitle;
@synthesize nextVC;
@synthesize categoryName;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title=self.pageTitle;
}

- (void)viewDidUnload
{
    [self setImageButton:nil];
    [self setTextButton:nil];
    [self setPageDescriptionLabel:nil];
    [self setChecklistDetailsLabel:nil];
    [self setFeatureDetailLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //configurable options
    self.pageTitle = nil;
    self.nextVC = nil;
    self.categoryName = nil;
}

- (IBAction)homesButtonClicked:(id)sender {
    [self.navigationController pushViewController:self.nextVC animated:YES];	
    
}

- (IBAction)checklistClicked:(id)sender {
    TaskTableViewController * taskVc = [[TaskTableViewController alloc] initWithNibName:@"TaskTableViewController" bundle:nil];
    
	taskVc.categoryName = self.categoryName;
	
	[self.navigationController pushViewController:taskVc animated:YES];
	
	[taskVc release];
}

#pragma mark -

- (void)dealloc {
    //Configurable
    [pageTitle release];
    [nextVC release];
    [categoryName release];
    [imageButton release];
    [textButton release];
    [pageDescriptionLabel release];
    [checklistDetailsLabel release];
    [featureDetailLabel release];
    [super dealloc];
}
@end
