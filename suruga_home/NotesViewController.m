//
//  NotesViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"

@implementation NotesViewController
@synthesize textView;
@synthesize home;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.text = self.home.notes;
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    self.home = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer in the navigation stack.
        self.home.notes = self.textView.text;
        
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [textView release];
    [home release];
    [super dealloc];
}
@end
