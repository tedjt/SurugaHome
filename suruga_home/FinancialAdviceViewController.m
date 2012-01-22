//
//  FinancialAdviceViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FinancialAdviceViewController.h"
#import "extThree20JSON/SBJson.h"
#import "FinancialAdvisorAnswerViewController.h"

@implementation FinancialAdviceViewController
@synthesize mTableView;

//TEMP
@synthesize options;
@synthesize questionLabel;
@synthesize imageView;
@synthesize dataDict;
@synthesize requestUrl;

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    
    if (self = [super init]) {
        //TODO -some initialization from query values
//        for (MyObject* item in [query objectForKey:@"arrayData"])
//            //... do something with item ...
//        }

    }
    return self;
}
# pragma mark PRIVATE FUNCTIONS
- (void)setUpViewFromDictionary {
    if (nil != dataDict && [@"question_slide" isEqualToString:[dataDict objectForKey:@"type"]]) {
        //Get the first page data
        NSArray * optionList = [dataDict objectForKey:@"option_list"];
        [self setOptions: [NSMutableArray arrayWithArray: optionList]];
        self.title = NSLocalizedString(@"Questions", @"Advisor Question Slide Title");
        self.questionLabel.text = [dataDict objectForKey:@"question"];
        self.imageView.image = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:[NSURL URLWithString:[dataDict objectForKey:@"question"]]]];
        [self.mTableView reloadData];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Start loading table view data
    responseData = [[NSMutableData data] retain];
	//tweets = [NSMutableArray array];
    if (nil != dataDict) {
        [self setUpViewFromDictionary];
    }
    else if (nil != requestUrl) {
        [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL: requestUrl] delegate:self];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:@"http://topangapetresort2.appspot.com/suruga"]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    //http://search.twitter.com/search.json?q=mobtuts&rpp=5
}

- (void)viewDidUnload
{
    self.mTableView = nil;
    [questionLabel release];
    questionLabel = nil;
    [self setQuestionLabel:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return (nil != options ? [options count] : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSDictionary *aOption = [options objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [aOption objectForKey:@"option_text"];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.font = [UIFont systemFontOfSize:12];
	cell.textLabel.minimumFontSize = 10;
	cell.textLabel.numberOfLines = 4;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	//cell.detailTextLabel.text = [aTweet objectForKey:@"from_user"];
	
	//NSURL *url = [NSURL URLWithString:[aTweet objectForKey:@"profile_image_url"]];
	//NSData *data = [NSData dataWithContentsOfURL:url];
	//cell.imageView.image = [UIImage imageWithData:data];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aOption = [options objectAtIndex:[indexPath row]];
    if ([@"question_slide" isEqualToString:[aOption objectForKey:@"next_type"]]) {
        FinancialAdviceViewController * vc = [[FinancialAdviceViewController alloc] initWithNibName:@"FinancialAdviceViewController" bundle:nil];
        vc.dataDict = [aOption objectForKey:@"next_slide"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else {
        //assume answer slide
        FinancialAdvisorAnswerViewController * vc = [[FinancialAdvisorAnswerViewController alloc] initWithNibName:@"FinancialAdvisorAnswerViewController" bundle:nil];
        vc.dataDict = [aOption objectForKey:@"next_slide"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    /*
     {
     "type": "question_slide",
     "question": "This is question1",
     "image_url": "www.test0_1.com",
     "option_list": [ {}, {}]
     }
     {"next_type": "answer_slide || question_slide",
     "option_text": "Option 1",
     "next_slide": { }
     }
     
     {"type" : "answer_slide",
     "overall_text": "When",
     "good_text": "1. asdf",
     "compare_text":"",
     "suruga_text": "Suruga Offers this card",
     "suruga_link": "http://suruga.jp"
     }
     */
    
    // Navigation logic may go here. Create and push another view controller.
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
    self.dataDict = [responseString JSONValue];
    [responseString release];
    [self setUpViewFromDictionary];
    /*
    {
        "type": "question_slide",
        "question": "This is question1",
        "image_url": "www.test0_1.com",
        "option_list": [ {}, {}]
    }
    {"next_type": "answer_slide || question_slide",
     "option_text": "Option 1",
     "next_slide": { }
    }
    
    {"type" : "answer_slide",
        "overall_text": "When",
        "good_text": "1. asdf",
        "compare_text":"",
        "suruga_text": "Suruga Offers this card",
        "suruga_link": "http://suruga.jp"
    }
     */
}


- (void)dealloc {
    [mTableView release];
    [questionLabel release];
    [imageView release];
    [super dealloc];
}
@end
