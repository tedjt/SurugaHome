//
//  WebThumbsViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WebThumbsViewController.h"

@implementation WebThumbsViewController
@synthesize parentController;

- (TTPhotoViewController*)createPhotoViewController {
    WebPhotoViewController *photoController = [[[WebPhotoViewController alloc] init] autorelease];
    photoController.parentController = self;
    return photoController;
}

@end
