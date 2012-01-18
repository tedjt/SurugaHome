//
//  Twitter_SearchViewController.h
//  Twitter Search
//
//  Created by John Wang on 6/9/10.
//  Copyright 2010 Fresh Blocks. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Twitter_SearchViewController : UITableViewController {
	NSArray *tweets;
}

@property (nonatomic, retain) NSArray *tweets;
@end
