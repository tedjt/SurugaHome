//
//  FinancialAdviceViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FinancialAdviceViewController.h"
#import "extThree20JSON/SBJson.h"

@implementation FinancialAdviceViewController
@synthesize mTableView;

//TEMP
@synthesize tweets;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Start loading table view data
    responseData = [[NSMutableData data] retain];
	//tweets = [NSMutableArray array];
	NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:@"http://topangapetresort2.appspot.com/suruga"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    //http://search.twitter.com/search.json?q=mobtuts&rpp=5
}

- (void)viewDidUnload
{
    self.mTableView = nil;
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
    
    return (nil != tweets ? [tweets count] : 0);
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
    
	NSDictionary *aTweet = [tweets objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [aTweet objectForKey:@"text"];
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
	
	NSDictionary *results = [responseString JSONValue];
	
	NSArray *allResults = [results objectForKey:@"results"];
    if (nil != allResults) {
        //Get the first page data
        NSArray * questionList = [[allResults objectAtIndex:0]  objectForKey:@"question_list"];
        self.title = [[allResults objectAtIndex:0]  objectForKey:@"text"];
        [self setTweets: [NSMutableArray arrayWithArray: questionList]];
        [self.mTableView reloadData];
    }
}


- (void)dealloc {
    [mTableView release];
    [super dealloc];
}
@end
