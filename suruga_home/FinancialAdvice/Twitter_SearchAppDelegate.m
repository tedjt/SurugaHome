//
//  Twitter_SearchAppDelegate.m
//  Twitter Search
//
//  Created by John Wang on 6/9/10.
//  Copyright Fresh Blocks 2010. All rights reserved.
//

#import "Twitter_SearchAppDelegate.h"
#import "Twitter_SearchViewController.h"
//#import "JSON.h"
#import "extThree20JSON/SBJson.h"

@implementation Twitter_SearchAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize tweets;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
	responseData = [[NSMutableData data] retain];
	tweets = [NSMutableArray array];
	NSURLRequest *request = [NSURLRequest requestWithURL:
							 [NSURL URLWithString:@"http://search.twitter.com/search.json?q=mobtuts&rpp=5"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

    return YES;
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
	
	NSArray *allTweets = [results objectForKey:@"results"];
	
	[viewController setTweets:allTweets];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
