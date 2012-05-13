//
//  SurplusDetailsViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurplusDetailsViewController : UIViewController {
    int initialSurplus;
    int runningSurplus;
}
@property (retain, nonatomic) IBOutlet UILabel *initialLabel;
@property (retain, nonatomic) IBOutlet UILabel *runningLabel;
@property (retain, nonatomic) IBOutlet UIButton *initialAdvice;
@property (retain, nonatomic) IBOutlet UIButton *runningAdvice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initialSurplus: (int) initialSurplusArg runningSurplus: (int) runningSurplusArg;
- (IBAction)getAdvice:(id)sender;

@end
