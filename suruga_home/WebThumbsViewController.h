//
//  WebThumbsViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "WebPhotoViewController.h"
@protocol WebPhotoDelegate;

@interface WebThumbsViewController : TTThumbsViewController {
    id<WebPhotoDelegate> parentController;    
}

@property (nonatomic, assign) id<WebPhotoDelegate> parentController;
@end

@protocol WebPhotoDelegate <NSObject>

@required
- (void) webThumbsViewController:(WebThumbsViewController *) webThumbsViewController didAddPhoto: (UIImage*) image;

@end
