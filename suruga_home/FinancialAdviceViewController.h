//
//  FinancialAdviceViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialAdviceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mTableView;
    
    //TEmp
    NSMutableData *responseData;
	NSMutableArray *tweets;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *tweets;

@end
