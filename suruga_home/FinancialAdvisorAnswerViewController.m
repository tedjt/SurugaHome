//
//  FinancialAdvisorAnswerViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FinancialAdvisorAnswerViewController.h"

@implementation FinancialAdvisorAnswerViewController
@synthesize overallDetailLabel;
@synthesize keyDetailLabel;
@synthesize compareDetailLabel;
@synthesize surugaLabel;
@synthesize overalTitleLabel;
@synthesize keyTitleLabel;
@synthesize compareTitleLabel;
@synthesize scrollView;
@synthesize dataDict;

# pragma mark PRIVATE FUNCTIONS
- (void)setUpViewFromDictionary {
    if (nil != dataDict && [@"answer_slide" isEqualToString:[dataDict objectForKey:@"type"]]) {
//        self.overallDetailLabel.text = [dataDict objectForKey:@"overall_text"];
//        self.keyDetailLabel.text = [dataDict objectForKey:@"good_text"];
//        self.compareDetailLabel.text = [dataDict objectForKey:@"compare_text"];
//        self.surugaLabel.text = [dataDict objectForKey:@"suruga_text"];
        self.title = NSLocalizedString(@"Advice", @"Advisor Answer Slide Title");
        
        //Attempt to resize and position labels:
        //- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
        //Overal title label
        CGSize maximumLabelSize = CGSizeMake(286,9999);
        CGFloat spacing = 5;
        CGFloat currentY = overallDetailLabel.frame.origin.y;
        
        //Get Text fields
        NSString *overalText = [dataDict objectForKey:@"overall_text"];
        NSString *keyText = [dataDict objectForKey:@"good_text"];
        NSString *compareText = [dataDict objectForKey:@"compare_text"];
        
        //HANDLE OVERALL DETAIL LABEL
        CGSize expectedLabelSize = [overalText sizeWithFont:overallDetailLabel.font 
            constrainedToSize:maximumLabelSize 
            lineBreakMode:overallDetailLabel.lineBreakMode]; 
        
        //adjust the label the the new height.
        CGRect newFrame = overallDetailLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        overallDetailLabel.frame = newFrame;
        
        currentY += expectedLabelSize.height + spacing;
        
        //HANDLE KEY TITLE LABEL
        newFrame = keyTitleLabel.frame;
        newFrame.origin.y = currentY;
        keyTitleLabel.frame = newFrame;
        
        currentY += keyTitleLabel.frame.size.height + spacing;
        
        ///////////BREAK////////////
        
        //HANDLE KEY DETAIL LABEL
        expectedLabelSize = [keyText sizeWithFont:keyDetailLabel.font 
            constrainedToSize:maximumLabelSize 
            lineBreakMode:keyDetailLabel.lineBreakMode]; 
        
        //adjust the label the the new height.
        newFrame = keyDetailLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        newFrame.origin.y = currentY;
        keyDetailLabel.frame = newFrame;
        
        currentY += expectedLabelSize.height + spacing;
        
        ///////////BREAK////////////
        
        //HANDLE KEY TITLE LABEL
        newFrame = compareTitleLabel.frame;
        newFrame.origin.y = currentY;
        compareTitleLabel.frame = newFrame;
        
        currentY += compareTitleLabel.frame.size.height + spacing;
        
        //HANDLE KEY DETAIL LABEL
        expectedLabelSize = [compareText sizeWithFont:compareDetailLabel.font 
            constrainedToSize:maximumLabelSize 
            lineBreakMode:compareDetailLabel.lineBreakMode]; 
        
        //adjust the label the the new height.
        newFrame = compareDetailLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        newFrame.origin.y = currentY;
        compareDetailLabel.frame = newFrame;
        
        currentY += expectedLabelSize.height + spacing;
        
        overallDetailLabel.text = overalText;
        keyDetailLabel.text = keyText;
        compareDetailLabel.text = compareText;
        
        //SET UP SCROLL VIEW
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, currentY)];
        //[self.scrollView setContentSize:CGSizeMake(320, (row+1) * 80 + 10)];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     {"type" : "answer_slide",
     "overall_text": "When",
     "good_text": "1. asdf",
     "compare_text":"",
     "suruga_text": "Suruga Offers this card",
     "suruga_link": "http://suruga.jp"
     }
     */
    [self setUpViewFromDictionary];
}

- (void)viewDidUnload
{
    [self setOverallDetailLabel:nil];
    [self setKeyDetailLabel:nil];
    [self setCompareDetailLabel:nil];
    [self setSurugaLabel:nil];
    self.overalTitleLabel = nil;
    self.keyTitleLabel = nil;
    self.compareTitleLabel = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [overallDetailLabel release];
    [keyDetailLabel release];
    [compareDetailLabel release];
    [surugaLabel release];
    [overalTitleLabel release];
    [keyTitleLabel release];
    [compareTitleLabel release];
    [dataDict release];
    [scrollView release];
    [super dealloc];
}
@end
