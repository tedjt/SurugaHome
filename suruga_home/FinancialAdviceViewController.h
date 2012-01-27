//
//  FinancialAdviceViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface FinancialAdviceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *mTableView;
    UILabel *questionLabel;
    UIImageView *imageView;
    UIActivityIndicatorView *loadingIndicator;
    
    //Data holders
    NSDictionary *dataDict;
    NSURL *requestUrl;
    NSMutableArray *options;
    NSMutableData *responseData;

}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) IBOutlet UILabel *questionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) NSDictionary *dataDict;
@property (nonatomic, retain) NSURL *requestUrl;
@property (nonatomic, retain) NSMutableData *responseData;

@end
