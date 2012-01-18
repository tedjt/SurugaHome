//
//  Twitter_SearchAppDelegate.h
//  Twitter Search
//
//  Created by John Wang on 6/9/10.
//  Copyright Fresh Blocks 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Twitter_SearchViewController;

@interface Twitter_SearchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Twitter_SearchViewController *viewController;
	NSMutableData *responseData;
	NSMutableArray *tweets;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Twitter_SearchViewController *viewController;
@property (nonatomic, retain) NSMutableArray *tweets;

@end

