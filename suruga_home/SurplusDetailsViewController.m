//
//  SurplusDetailsViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurplusDetailsViewController.h"
#import "FinancialAdviceViewController.h"

@implementation SurplusDetailsViewController
@synthesize initialLabel;
@synthesize runningLabel;
@synthesize initialAdvice;
@synthesize runningAdvice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initialSurplus: (int) initialSurplusArg runningSurplus: (int) runningSurplusArg {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        initialSurplus = initialSurplusArg;
        runningSurplusArg = runningSurplusArg;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the label texts.
    if (initialSurplus > 0) {
        initialLabel.text = NSLocalizedString(@"You should consider options for saving your positive initial surplus.", @"Initial surplus positive description");
    } else {
        initialLabel.text = NSLocalizedString(@"You should consider funding options to cover your deficit in current savings and cover your fixed costs.", @"Initial surplus negative description");
    }
    if (runningSurplus > 0) {
        runningLabel.text = NSLocalizedString(@"Consider options for saving part of your monthly income.", @"Running surplus positive description");
    } else {
        runningLabel.text = NSLocalizedString(@"Find ways to reduce your expenses or fund your monthly budget deficit.", @"Running surplus negative description");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.initialLabel = nil;
    self.runningLabel = nil;
    self.initialAdvice = nil;
    self.runningAdvice = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [initialLabel release];
    [runningLabel release];
    [initialAdvice release];
    [runningAdvice release];
    [super dealloc];
}

- (IBAction)getAdvice:(id)sender {
    //TODO customize advisor entry points.
    FinancialAdviceViewController * vc = [[FinancialAdviceViewController alloc] initWithNibName:@"FinancialAdviceViewController" bundle:nil]; 
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
