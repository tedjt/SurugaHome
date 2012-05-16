//
//  SimpleSurplusViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleSurplusViewController.h"
#import "FinancialAdviceViewController.h"

@implementation SimpleSurplusViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)adviceButtonClicked:(id)sender {
    FinancialAdviceViewController * vc = [[FinancialAdviceViewController alloc] initWithNibName:@"FinancialAdviceViewController" bundle:nil]; 
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
