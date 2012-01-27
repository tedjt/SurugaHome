//
//  FinancialAdvisorAnswerViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialAdvisorAnswerViewController : UIViewController {
    UILabel *overallDetailLabel;
    UILabel *keyDetailLabel;
    UILabel *compareDetailLabel;
    UILabel *surugaLabel;
    UILabel *overalTitleLabel;
    UILabel *keyTitleLabel;
    UILabel *compareTitleLabel;
    UIActivityIndicatorView *loadingIndicator;
    UIScrollView *scrollView;
    NSDictionary * dataDict;
    NSURL *requestUrl;
    NSMutableData *responseData;

}

@property (nonatomic, retain) IBOutlet UILabel *overallDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *keyDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *compareDetailLabel;
@property (nonatomic, retain) IBOutlet UILabel *surugaLabel;
@property (nonatomic, retain) IBOutlet UILabel *overalTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *keyTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *compareTitleLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSDictionary *dataDict;
@property (nonatomic, retain) NSURL *requestUrl;
@property (nonatomic, retain) NSMutableData *responseData;

@end
